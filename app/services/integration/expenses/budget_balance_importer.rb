#
# Importador de dados do Web Service de Saldo Orçamentário
#
class Integration::Expenses::BudgetBalanceImporter < Integration::Expenses::BaseExpensesImporter

  protected

  def import(kind)

    line = 0

    for_each_month_year do |month, year|
      @current_month = month
      @current_year = year

      resources(kind).each do |attributes|

        line += 1
        send("import_#{kind}", attributes, line)
      end
    end

    log(:info, I18n.t("services.importer.log.#{kind}", line: line))

  end

  private

  def model_klass
    Integration::Expenses::BudgetBalance
  end


  def call_service_for_each_month_year(service_klass)
    current_year = Date.current.year
    current_month = Date.current.month

    #
    # importando as combinações de períodos mensal dentro de um determinado ano
    #
    (1..current_month).each do |month_start|
      month_range = { month_start: month_start, month_end: current_month }

      service_klass.call(current_year, 0, month_range)
    end
  end


  def create_stats_klass
    Integration::Expenses::BudgetBalances::CreateStats
  end

  def create_spreadsheet_klass
    Integration::Expenses::BudgetBalances::CreateSpreadsheet
  end

  def stats_yearly?
    true
  end

  def import_budget_balance(attributes, line)
    # É preciso utilizar find_or_initialize
    # para garantir que vamos inserir apenas os novos.
    # Isso permite reprocessar dados sem ter que apagar dados
    # o que pode ser inconveniente durante o horario comercial

    budget_balance = find_or_initialize(attributes)
    update(budget_balance, attributes, line) #if budget_balance.new_record?
  end

  def find_or_initialize(attributes)
    attributes_to_find = attributes.dup.slice(:ano_mes_competencia, :classif_orcam_reduz) # duplicando porque o parametro é por referencia
    #attributes_to_find.delete(:data_atual) # a data atual é sempre diferente
    model_klass.find_or_initialize_by(attributes_to_find)
  end

  def message(kind)
    {
      usuario: @configuration.send("#{kind}_user"),
      senha: @configuration.send("#{kind}_password"),
      mes: month,
      exercicio: year,
      unidade_gestora: ''
    }
  end

  def month
    @current_month
  end

  def year
    @current_year
  end
end
