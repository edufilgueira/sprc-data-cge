class Integration::Servers::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :arqfun_ftp_address,
    :arqfun_ftp_user,
    :arqfun_ftp_password,
    :arqfin_ftp_address,
    :arqfin_ftp_user,
    :arqfin_ftp_password,
    :rubricas_ftp_address,
    :rubricas_ftp_user,
    :rubricas_ftp_password,
    :schedule,
    presence: true


  # Instace methods

  ## Helpers

  def current_month
    # Se algum mês específico estiver definido, todo o processo de download,
    # registro e consolidação dos dados será feito para o mês.
    # Caso o campo mês esteja em branco, será considerado o mês corrente.

    month.present? ? safe_month(month) : I18n.l(Date.today, format: :month_year)
  end

  #
  # Retorna o path onde os arquivos FTP devem ser gravados.
  # Cria o diretório, caso não exista.
  #
  def download_path
    return nil unless persisted?

    year = current_month.split('/')[1]
    month = current_month.split('/')[0]
    year_month = "#{year}#{month}"

    path = Rails.root.to_s + "/files/integration/servers/#{id}/#{year_month}/"

    unless Dir.exist?(path)
      FileUtils::mkdir_p(path)
    end

    path
  end

  # Privates

  private

  def importer_class
    Integration::Servers::Importer
  end

  def safe_month(month)
    year = month.split('/')[1]
    month = month.split('/')[0]

    month = "0#{month}" if (month.to_i < 10 && month.size == 1)

    "#{month}/#{year}"
  end
end
