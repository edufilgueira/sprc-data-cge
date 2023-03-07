class Integration::Revenues::Importer < Integration::Supports::BaseSupportsImporter

  attr_reader :reference_month

  def initialize(configuration_id)
    super

    @account_configurations = @configuration.account_configurations

    # Precisamos guardar o valor do mês antes, e não depender mais do
    # configuration, para permitir que outros processo de
    # importação rodem paralelo e que as estatísticas/planilhas, criadas no
    # final do processo, sejam geradas com a data esperada.

    @reference_month = reference_month_from_configuration
  end

  def call
    start

    begin

      @account_configurations.each do |account|

        revenues_for_account(account)
      end

      create_stats
      create_spreadsheet

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  private

  def configuration_class
    Integration::Revenues::Configuration
  end

  def revenues_for_account(account)
    lines = 0
    begin

      resources(account.account_number).each do |attributes|
        next unless attributes[:poder] == 'EXECUTIVO'

        revenue = initialize_revenue(account, attributes)

        accounts = attributes.delete(:contas_correntes)

        revenue.update_attributes(attributes)

        create_or_update_accounts(revenue, accounts)

        lines += 1
      end


      log(:info, I18n.t('services.importer.log.revenue', lines: lines, account: account.account_number))

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: "#{account.account_number}/#{e.message}"))
    end
  end

  def initialize_revenue(account, attributes)
    revenue = Integration::Revenues::Revenue.find_or_initialize_by(revenue_params(account, attributes))
    revenue
  end

  def revenue_params(account, attributes)
    {
      account_configuration: account,
      unidade: attributes[:unidade],
      month: reference_month.month,
      year: reference_month.year
    }
  end

  def create_or_update_accounts(revenue, accounts)
    accounts_attributes(accounts).each do |attributes|
      account = revenue.accounts.find_or_initialize_by(conta_corrente: attributes[:conta_corrente])

      account.update_attributes(attributes)
    end
  end

  def accounts_attributes(accounts)
    return [] unless accounts.present?

    attributes = accounts[:conta]

    attributes.is_a?(Hash) ? [attributes] : attributes
  end

  def message(account_number)
    {
      usuario: @configuration.user,
      senha: @configuration.password,
      filtro: {
        mes: reference_month.month,
        exercicio: reference_month.year,
        conta: account_number
      }
    }
  end

  def response_path(prefix=nil)
    # o prefix é usado em alguns importers como revenues, ...

    @configuration.response_path.split('/').map(&:to_sym)
  end

  def operation(prefix=nil)
    @configuration.operation.to_sym
  end

  def create_stats
    create_month_account_stats_combinations

    Integration::Revenues::Transfers::CreateStats.call(reference_month.year, 0)
    Integration::Revenues::RegisteredRevenues::CreateStats.call(reference_month.year, 0)
  end

  def create_spreadsheet
    create_month_account_spreadsheets_combinations

    Integration::Revenues::Transfers::CreateSpreadsheet.call(reference_month.year, 0)
    Integration::Revenues::RegisteredRevenues::CreateSpreadsheet.call(reference_month.year, 0)
  end

  def create_month_account_stats_combinations
    current_year = reference_month.year
    current_month = reference_month.month

    #
    # importando as combinações de períodos mensal dentro de um determinado ano
    #
    (1..current_month).each do |month_start|
      month_range = { month_start: month_start, month_end: current_month }

      Integration::Revenues::Accounts::CreateStats.call(current_year, 0, month_range)
    end
  end

  def create_month_account_spreadsheets_combinations
    current_year = reference_month.year
    current_month = reference_month.month

    #
    # importando as combinações de períodos mensal dentro de um determinado ano
    #
    (1..current_month).each do |month_start|
      month_range = { month_start: month_start, month_end: current_month }

      Integration::Revenues::Accounts::CreateSpreadsheet.call(current_year, 0, month_range)
    end
  end

  #
  # Atenção: esse método é chamado apenas na inicialização do serviço. Para
  # referenciar o mês corrente use 'reference_month'
  #
  def reference_month_from_configuration
    @reference_month_from_configuration ||=
      (@configuration.month.present? ? Date.parse(@configuration.month) : Date.current.last_month)
  end
end
