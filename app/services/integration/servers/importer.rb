require 'net/ftp'

class Integration::Servers::Importer
  include LogImporter

  FILE_TYPES = {
    registrations: :arqfun,
    proceeds: :arqfin,
    proceed_types: :rubricas
  }

  PROCEEDS_TYPE_FILE_COLUMN_DELIMETER = ';'

  COLUMNS_RANGE = {

    registrations: {
      cod_orgao: 0..2,
      dsc_matricula: 3..10,
      dsc_funcionario: 11..110,
      dsc_cargo: 111..160,
      dth_nascimento: 161..168,
      dsc_cpf: 169..179,
      num_folha: 180..183,
      cod_situacao_funcional: 184..184,
      cod_afastamento: 185..186,
      dth_afastamento: 187..194,
      vlr_carga_horaria: 195..199,
      vdth_admissao: 200..207
    },

    proceeds: {
      cod_orgao: 0..2,
      dsc_matricula: 3..10,
      num_ano: 11..14,
      num_mes: 15..16,
      cod_processamento: 17..17,
      cod_provento: 18..22,
      vlr_financeiro: 23..43,
      vlr_vencimento: 44..64
    },

    proceed_types: {
      cod_provento: 0,
      dsc_provento: 1,
      dsc_tipo: 2,
      origin: 3
    }
  }

  WORKERS = {
    registrations: Integration::Servers::Workers::RegistrationWorker,
    proceeds: Integration::Servers::Workers::ProceedWorker,
    proceed_types: Integration::Servers::Workers::ProceedTypeWorker,
  }

  DEFAULT_ORIGINS = [:seplag, :metrofor]



  # O status vai do 205 até o final da linha
  REGISTRATION_STATUS_SITUACAO_FUNCIONAL_START = 205

  attr_reader :configuration, :logger, :ftp_downloader_seplag, :ftp_downloader_metrofor, :current_month, :year, :month, :origin

  def initialize(id)
    
    @configuration = Integration::Servers::Configuration.find(id)
    @logger = Logger.new(log_path)

    @current_month = configuration.current_month
    @year = current_month.split('/')[1].to_i
    @month = current_month.split('/')[0].to_i

    @ftp_downloader_seplag = Integration::Servers::ServerSalaries::FtpDownloader.new(@configuration)
    @ftp_downloader_metrofor = Integration::Servers::ServerSalaries::FtpDownloaderMetrofor.new(@configuration)

  end

  def self.call(id)
    new(id).call
  end

  def call
    start
    success_count = 0
    [:proceed_types, :registrations, :proceeds].each do |file_type|
      origin_types_import.each do |origin|
        
        log(:info, "Importando: #{origin} - #{file_type}")
        @origin = origin
        success_count += ( import_data_for(file_type, origin) ? 1 : 0 )

        sleep(20)
        while sidekiq_queue_size != 0
          sleep(20)
          log(:info, "Aguardando Encerrar importação: #{file_type} - #{sidekiq_queue_size}")
        end
      end
    end

    create_server_salaries
    
    finish_log
  end

  private

  def sidekiq_stats
    @sidekiq_stats = Sidekiq::Stats.new #avaliar se muda os dados
  end

  def sidekiq_queue_size
    sidekiq_stats.queues['servers_import'].to_i
  end

  def local_import_file_path(type, origin)
    {
      registrations: "/home/saulo/Downloads/arquivos_servidores/#{origin}/ARQFUN.txt",
      proceeds: "/home/saulo/Downloads/arquivos_servidores/#{origin}/ARQFIN.txt",
      proceed_types: "/home/saulo/Downloads/arquivos_servidores/#{origin}/RUBRICA.txt"
    }[type]
  end

  def download_file(file_type, origin)
    return File.read(local_import_file_path(file_type, origin)) if Rails.env.development?
    send("ftp_downloader_#{origin}").download_file(FILE_TYPES[file_type])
  end

  def origin_types_import
    ENV['ORIGIN'] ? [ENV['ORIGIN'].to_sym] : DEFAULT_ORIGINS
  end


  def import_data_for(file_type, origin)
    file_content = download_file(file_type, origin)

    # Scrub é utilizado para substituir caracteres ilegíveis
    # Usado apenas em desenv para validar arquivo com problemas
    #file_content = file_content.scrub #remover linha antes de ir para produção

    if !file_content.nil?
      lines = send("#{file_type}_import", file_content)
      log(:info, I18n.t("services.importer.log.#{file_type}", lines: lines))
      return true
    else
      log(:error, send("ftp_downloader_#{origin}").last_error)
      return false
    end
  end

  def registrations_import(file_content)
    import(file_content, :registration_parse, :registrations)
  end

  def proceed_types_import(file_content)
    import(file_content, :proceed_types_parse, :proceed_types)
  end


  
  def first_proceed_insert
    @first_proceed_insert = false if @first_proceed_insert
    @first_proceed_insert = true if @first_proceed_insert == nil
    @first_proceed_insert
  end

  def proceeds_import(file_content)
    # Por questões de performance
    # Proceeds é totalmente apagada a cada importação.
    # E os registros são inseridos diretametne, evitando o find or initialize
    Integration::Servers::Proceed.where(num_ano: @year, num_mes: @month).delete_all if first_proceed_insert
    import_proceeds(file_content, :proceeds_parse)
  end

  def import_proceeds(file_content, proceeds_parse)
    return if file_content.blank?
    lines_count = 0

    begin

      file_content.lines.each_slice(900) do |lines|
        #montar insert e fazer join com proxima linha
        proceed_model.connection.execute("insert into #{proceed_model.table_name} (#{proceeds_collumns}) values #{proceed_lines_to_sql(lines)} ;")
        lines_count+= lines.count
      end

    rescue StandardError => e
      configuration.status_fail!
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      return lines_count
    end
    
    return lines_count
  end

  def proceeds_collumns
    default = COLUMNS_RANGE[:proceeds].keys
    default.concat [:created_at, :updated_at, :full_matricula]
    default.join(', ')
  end

  def proceed_convert_one_line_to_insert(line)
    date = DateTime.now
    values = proceeds_parse(line).values
    record = "("
    record << "'#{values[0]}'," #:cod_orgao
    record << "'#{values[1]}'," #:dsc_matricula
    record << "#{values[2]},"   #:num_ano
    record << "#{values[3]},"   #:num_mes
    record << "'#{values[4]}'," #:cod_processamento
    record << "'#{values[5]}'," #:cod_provento
    record << "'#{values[6]}'," #vlr_financeiro
    record << "'#{values[7]}'," #vlr_vencimento
    record << "'#{date}',"      #created_at
    record << "'#{date}',"      #updated_at
    record << "'#{values[0]}/#{values[1]}')" #fullmatricula
    record
  end

  def proceed_lines_to_sql(lines)
    lines.map{|line| proceed_convert_one_line_to_insert(line) }.join(', ')
  end


  def import(file, parser, file_type)
    return if file.blank?
    lines_count = 0

    begin
      blocks = (file.lines.count/3)
      file.lines.each_slice(blocks) do |lines|
        Thread.new do
          lines.each do |line|
            WORKERS[file_type].perform_async(line, send(parser, line))
            lines_count += 1
          end
        end        
      end
    rescue StandardError => e
      configuration.status_fail!
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      return lines_count
    end
    return lines_count
  end

  def parse_line(file_type, line)
    hash = {}
    columns_range[file_type].map do |key, range|
      hash[key] = line[range]
    end
    yield(hash) if block_given?
    hash
  end

  def registration_parse(line)
    parse_line(:registrations, line) do |registration|
      registration[:dsc_cargo] = safe_strip(registration[:dsc_cargo])
      registration[:dsc_funcionario] = safe_strip(registration[:dsc_funcionario])
      registration[:status_situacao_funcional] = status_situacao_funcional(line)
    end
  end

  def proceeds_parse(line)
    parse_line(:proceeds, line) do |proceeds|
      proceeds[:vlr_financeiro].insert(19, '.')
      proceeds[:vlr_vencimento].insert(19, '.')
    end
  end

  def proceed_types_parse(line)
    data = line.split(PROCEEDS_TYPE_FILE_COLUMN_DELIMETER)

    if data.present? && data.length > 0
      data[data.length - 1] = safe_strip(data.last)
      data << origin
      parse_line(:proceed_types, data)
    end
  end

  def finish_log
    close_log
    configuration.status_success! unless configuration.status_fail?
    configuration.save!
  end

  def find_organ(cod_orgao)
    Integration::Supports::Organ.find_by(data_termino: nil, codigo_folha_pagamento: cod_orgao)
  end

  ## Services

  def create_server_salaries
    log(:info, "[SERVERS] Criando server_salaries para #{current_month}.")
    Integration::Servers::ServerSalaries::CreateServerSalaries.call(current_month, @configuration)
    log(:info, "[SERVERS] server_salaries para #{current_month} criados.")
  end

  def status_situacao_funcional(line)
    start = registration_status_situacao_funcional_start
    finish = line.length
    cols = safe_strip(line[start, finish])
  end

  def safe_strip(string)
    return '' if string.blank?
    string.strip
  end

  def columns_range
    COLUMNS_RANGE
  end

  def registration_status_situacao_funcional_start
    REGISTRATION_STATUS_SITUACAO_FUNCIONAL_START + 3
  end

  def proceed_model
    Integration::Servers::Proceed
  end
end
