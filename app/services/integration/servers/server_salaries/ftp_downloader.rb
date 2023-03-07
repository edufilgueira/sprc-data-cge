require 'net/ftp'

class Integration::Servers::ServerSalaries::FtpDownloader

  # XXX: é preciso refatorar o configurador para:
  # 1) ter apena uma config de ftp usada pra os 3 arquivos.
  # 2) adicionar porta do ftp as configurações.

  attr_accessor :ftp_port

  FTP_FILE_PREFIXES = {
    arqfun: "ARQFUN05*",
    arqfin: "ARQFIN05*",
    rubricas: "Rubricas*"
  }

  attr_reader :configuration, :last_error, :current_month

  def initialize(configuration)
    @configuration = configuration

    @current_month = configuration.current_month
  end

  def file_content(file_type)
    @last_error = ''
    ftp_file_content(file_type)
  end

  def download_file(file_type)
    ftp_download_file(file_type)
  end

  private

  def ftp_registrations_file
    ftp_file_content(:arqfun)
  end

  def ftp_proceeds_file
    ftp_file_content(:arqfin)
  end

  def ftp_proceeds_type_file
    ftp_file_content(:rubricas)
  end

  def ftp_params(prefix)
    file_prefix = FTP_FILE_PREFIXES[prefix]

    {
      address: @configuration.send("#{prefix}_ftp_address"),
      user: @configuration.send("#{prefix}_ftp_user"),
      password: @configuration.send("#{prefix}_ftp_password"),
      passive: Rails.env.development? ? true : @configuration.send("#{prefix}_ftp_passive"),
      dir: @configuration.send("#{prefix}_ftp_dir"),
      prefix: file_prefix,
      filename: ftp_download_filename(prefix)
    }
  end

  def ftp_file_content(prefix, destination=nil)
    params = ftp_params(prefix)

    begin
      ftp = Net::FTP.new
      ftp.connect(params[:address], ftp_port)
      ftp.login(params[:user], params[:password])
      ftp.chdir(params[:dir])
      ftp.passive = params[:passive]
      filename = params[:filename]

      if destination.blank?
        return ftp.getbinaryfile(filename, nil).force_encoding('iso8859-1').encode('utf-8')
      else
        ftp.getbinaryfile(filename, destination)

        return File.read(destination).force_encoding('iso8859-1').encode('utf-8')
      end
    rescue StandardError => e
      register_last_error(params, e)
      return nil
    end
  end

  def ftp_download_file(file_type)
    filename = ftp_download_filename(file_type)
    destination = "#{configuration.download_path}/#{filename}"

    ftp_file_content(file_type, destination)
  end

  def ftp_download_filename(file_type)
    file_prefix = FTP_FILE_PREFIXES[file_type]

    file_prefix.gsub('*', "_#{year_month}.txt")
  end

  def ftp_port
    @ftp_port || 21
  end

  def register_last_error(params, exception)
    @last_error = I18n.t('services.importer.log.access', address: params[:address], dir: params[:dir], filename: params[:filename], e: exception)
  end

  # Nesta lógica apenas é processado o último arquivo (mais recente)
  # que está dentro do diretório FTP
  #
  # Ex:
  # ARQFUN05_201703.txt não é processado
  # ARQFUN05_201704.txt é processado
  def ftp_filename(ftp, prefix)
    final_filename = final_filename_regex(prefix)
    ftp.nlst(final_filename).last
  end


  # Monta a regex de busca do arquivo final
  # se existir uma data nos parâmentros de configuração
  #
  # Ex:
  # ARQFUN05_* => ARQFUN05_201709*
  # ARQFIN05_* => ARQFIN05_201709*
  # Rubricas_* => Rubricas_201709*
  def final_filename_regex(prefix)
    return prefix.gsub('*', "_#{year_month}*")
  end

  def year_month
    date = current_month

    if date.present?
      date = date.split('/')
      month = date[0]
      year = date[1]
      "#{year}#{month}"
    end
  end
end
