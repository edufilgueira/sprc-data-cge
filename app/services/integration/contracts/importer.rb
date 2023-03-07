class Integration::Contracts::Importer < Integration::Supports::BaseSupportsImporter

  BLANK_DATE = Date.parse('Sat, 01 Jan 0001')

  def initialize(configuration_id)
    super

    @start_at = @configuration.start_at || Date.today.beginning_of_month
    @end_at = @configuration.end_at || Date.today.end_of_month

    @contracts_to_sum = []

    # months_to_update_stats é mes/ano do intervalo passado 
    # via parametro

    @months_to_update_stats = {
      contracts: month_year_interval_param,
      convenants: month_year_interval_param
    }
  end

  def call
    start
    
    log(:info, "[CONTRACTS] - Iniciando importação para o período: #{@start_at} até #{@end_at}.")

    import_data
  end


  private

  def import_data
    begin
      import_contracts
      import_additives
      import_adjustments
      import_financials
      import_infringements
      update_contracts_situation_base

      if @contracts_to_sum.count > 0
        log(:info, "[CONTRACTS] - Detectada alteração em #{@contracts_to_sum.count} contratos. Recalculando valores, estatísticas e planilhas para os meses: #{@months_to_update_stats}.")

        calculate_sums

        create_contracts_nesteds_spreadsheet

        create_stats

        create_spreadsheets
      end

      close_log

      @configuration.status_success!

    rescue StandardError => e
      log(:error, "[CONTRACTS] - #{@contracts_to_sum} - #{parsed_start_at} / #{parsed_end_at}  - #{I18n.t('services.importer.log.error', e: e.message)}")

      close_log
      @configuration.status_fail!
    end
  end

  def configuration_class
    Integration::Contracts::Configuration
  end

  def import(kind)
    line = 0

    changed_attrs = []

    resources(kind).each do |attributes|
      line += 1

      # O serviço de importação, traz datas de audutoria Sat, 01 Jan 0001 (???)
      # Já o de atualização, traz as datas corretamente.
      # Temos que garantir que a data_auditoria mais nova não seja sobrescrita.

      data_auditoria = (attributes[:data_auditoria].present? && Date.parse(attributes[:data_auditoria])) rescue nil

      if (data_auditoria.nil? || (data_auditoria == BLANK_DATE))
        attributes.delete :data_auditoria
      end

      resource = yield(attributes)

      safe_assign_attributes(resource, attributes)

      if resource.changed?
        changed_attrs += resource.changed_attributes.keys

        # Essa data_processamento retorna sempre a data que é invocada, fazendo com que os
        # contratos sejam atualizados desnecessariamente
        changed_attrs = changed_attrs.uniq - ['data_processamento']

        if resource.save
          if changed_attrs.present? and kind != :infringement
            add_resource_or_contract_or_convenant_to_sum(resource)
          end

          update_infringement_status(resource)
        end
      end
    end

    log(:info, "[CONTRACTS] changed #{kind}: #{changed_attrs}")
    log(:info, I18n.t("services.importer.log.#{kind}", line: line))
  end

  def resources(prefix)
    result_array = response_path(prefix).inject(body(prefix)) do |result, key|
      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def response_path(prefix)
    @configuration.send("#{prefix}_response_path").split('/').map(&:to_sym)
  end

  def response(prefix=nil)
    @client.call(operation(prefix), advanced_typecasting: false, message: message(prefix))
  end

  def import_contracts
    log(:info, "[CONTRACTS] - Iniciando")

    import(:contract) do |attributes|
      contract = find_contract_or_convenant(attributes[:isn_sic])
      contract.infringement_status = :adimplente

      contract
    end
  end

  def import_additives
    log(:info, "[ADDITIVES] - Iniciando")

    import(:additive) do |attributes|
      additive = Integration::Contracts::Additive.find_or_initialize_by(isn_contrato_aditivo: attributes[:isn_contrato_aditivo])

      additive
    end
  end

  def import_adjustments
    log(:info, "[ADJUSTMENTS] - Iniciando")

    import(:adjustment) do |attributes|
      Integration::Contracts::Adjustment.find_or_initialize_by(isn_contrato_ajuste: attributes[:isn_contrato_ajuste])
    end
  end

  def import_financials
    log(:info, "[FINANCIALS] - Iniciando")

    import(:financial) do |attributes|
      Integration::Contracts::Financial.find_or_initialize_by(financial_finder(attributes))
    end
  end

  def import_infringements
    log(:info, "[INFRIGIMENTS] - Iniciando")
    Integration::Contracts::Infringement.delete_all

    import(:infringement) do |attributes|
      Integration::Contracts::Infringement.find_or_initialize_by(isn_sic: attributes[:isn_sic])
    end
  end

  def update_infringement_status(resource)

    if (resource.is_a?(Integration::Contracts::Infringement) && resource.contract.present?)
      infringement_status = Integration::Contracts::Contract.infringement_statuses[:inadimplente]

      if (resource.contract.persisted?)
        resource.contract.update_column(:infringement_status, infringement_status)
      end
    end
  end

  def create_stats
    unless ENV['BYPASS_STATS'] == 'true'

      # cria estatística para cada mês do intervalo que foi importado.
      log(:info, "[CONTRACTS] - Atualizando estatísticas para meses #{@months_to_update_stats}")

      for_each_months(@months_to_update_stats[:contracts]) do |month, year|
        Integration::Contracts::Contracts::CreateStats.call(year, month)
        Integration::Contracts::ManagementContracts::CreateStats.call(year, month)
      end

      for_each_months(@months_to_update_stats[:convenants]) do |month, year|
        Integration::Contracts::Convenants::CreateStats.call(year, month)
      end
    end
  end

  def create_spreadsheets
    unless ENV['BYPASS_SPREADSHEETS'] == 'true'
      log(:info, "[CONTRACTS] - Atualizando planilhas para meses #{@months_to_update_stats}")
      
      # cria planilha para cada mês do intervalo que foi importado.
      
      for_each_months(@months_to_update_stats[:contracts]) do |month, year|
        Integration::Contracts::Contracts::CreateSpreadsheet.call(year, month)
        Integration::Contracts::ManagementContracts::CreateSpreadsheet.call(year, month)
      end

      for_each_months(@months_to_update_stats[:convenants]) do |month, year|
        Integration::Contracts::Convenants::CreateSpreadsheet.call(year, month)
      end
    end
  end

  def create_contracts_nesteds_spreadsheet
    #
    # cria as planilhas dos nesteds de contratos e convenios com mais de 20 registros
    #

    if @contracts_to_sum.present?
      # A linha do Eparcerias::TransferBankOrders foi comentada pois
      # não é importado nesse momento. Ela deve ser gerada
      # na importação do eparcerias

      #Integration::Eparcerias::TransferBankOrders::CreateSpreadsheet.call(@contracts_to_sum)
      Integration::Contracts::Financials::CreateSpreadsheet.call(@contracts_to_sum)
    end
  end

  def calculate_sums
    uniq_contracts_to_sum = @contracts_to_sum

    Integration::Contracts::Contract.transaction do
      Integration::Contracts::Contract.unscoped.where(isn_sic: uniq_contracts_to_sum).find_each(batch_size: 100) do |contract|
        contract.calculated_valor_ajuste = contract.valor_ajuste
        contract.calculated_valor_aditivo = contract.valor_aditivo
        contract.calculated_valor_empenhado = contract.valor_empenhado
        contract.calculated_valor_pago = contract.valor_pago

        contract.save
      end
    end
  end

  def add_resource_or_contract_or_convenant_to_sum(resource)

    @contracts_to_sum << resource.isn_sic
    @contracts_to_sum = @contracts_to_sum.compact.uniq

    contract = resource.is_a?(Integration::Contracts::Contract) ? resource : resource.contract
    if contract.present?
      contract_month = "#{contract.data_assinatura.month}/#{contract.data_assinatura.year}"

      # @months_to_update_stats agora é baseado na data de inicio e fim de importação
      # definido no initialize da classe

      # if contract.convenio?
      #   @months_to_update_stats[:convenants] = (@months_to_update_stats[:convenants] + [contract_month]).uniq
      # else
      #   @months_to_update_stats[:contracts] = (@months_to_update_stats[:contracts] + [contract_month]).uniq
      # end
    end
  end

  # Helpers

  def contract_class(flg_tipo)
    if flg_tipo.in?(Integration::Contracts::Contract::KIND[:convenio])
      Integration::Contracts::Convenant
    else
      Integration::Contracts::Contract
    end
  end

  def find_contract_or_convenant(isn_sic)
    Integration::Contracts::Contract.unscoped.find_or_initialize_by(isn_sic: isn_sic)
  end

  def financial_finder(attributes)
    {
      ano_documento: attributes[:ano_documento],
      cod_gestor: attributes[:cod_gestor],
      num_documento: attributes[:num_documento]
    }
  end

  def message(prefix)
    msg = @configuration.send("#{prefix}_parameters")
    default_message.merge(message_underscore(msg, prefix))
  end

  def message_underscore(msg, prefix)
    parse_message(msg, prefix).transform_keys { |k| k.underscore.to_sym }
  end

  def parse_message(msg, prefix)
    Rack::Utils.parse_nested_query(message_without_placeholder(msg, prefix))
  end

  def message_without_placeholder(msg = "", prefix)
    msg = msg.gsub('BEGIN_MONTH', parsed_start_at)
    msg.gsub('END_MONTH', parsed_end_at)
  end

  def parsed_start_at
    @parsed_start_at || parse_date(@start_at)
  end

  def parsed_end_at
    @parsed_end_at || parse_date(@end_at)
  end

  def parse_date(date)
    date.strftime('%d/%m/%Y')
  end

  def for_each_months(months)
    months.each do |month_year|
      month = month_year.split('/')[0].to_i
      year = month_year.split('/')[1].to_i

      yield(month, year)
    end
  end

  def daily_updater?
    self.instance_of?(Integration::Contracts::DailyUpdater)
  end

  def update_contracts_situation_base
  	# Cria a tabela base com as situações dos contratos, usada para carregar a combo nas pesquisas
    contract_class(:contract).unscope(:where).distinct.pluck(:descricao_situacao).each do |situation|
      contracts_situation_class.find_or_create_by(description: situation)
    end
  end

  def contracts_situation_class
    Integration::Contracts::Situation
  end

  def month_year_interval_param
    ["#{@start_at.month}/#{@start_at.year}", "#{@end_at.month}/#{@end_at.year}"].uniq
  end

end
