#
# Importador de dados do Web Service de NED
#
class Integration::Expenses::NedImporter < Integration::Expenses::BaseExpensesImporter

  NAMESPACES = %w{
    Integration::Expenses::Neds
    Integration::Expenses::Dailies
    Integration::Expenses::CityTransfers
    Integration::Expenses::ProfitTransfers
    Integration::Expenses::NonProfitTransfers
    Integration::Expenses::MultiGovTransfers
    Integration::Expenses::ConsortiumTransfers
    Integration::Expenses::FundSupplies
  }

  private

  def model_klass
    Integration::Expenses::Ned
  end

  def create_stats_klass
    Integration::Expenses::Neds::CreateStats
  end

  def create_stats
    unless ENV['BYPASS_STATS'] == 'true'
      years.each do |year|
        NAMESPACES.each do |namespace|
          logger.info("[EXPENSES] - Gerando estatísticas para #{namespace} [#{year}].")
          stats_service_class = "#{namespace}::CreateStats".constantize
          stats_service_class.call(year, 0)
        end
      end
    end
  end

  def create_spreadsheets
    unless ENV['BYPASS_SPREADSHEETS'] == 'true'
      years.each do |year|
        NAMESPACES.each do |namespace|
          logger.info("[EXPENSES] - Gerando planilhas para #{namespace} [#{year}].")
          spreadsheets_service_class = "#{namespace}::CreateSpreadsheet".constantize
          spreadsheets_service_class.call(year, 0)
        end
      end
    end
  end

  def import_ned(attributes, line)

    return if attributes.blank?

    ned = find_or_initializer(model_klass, attributes)

    deleted_lists_attributes = remove_lists_attributes(attributes)

    update(ned, attributes, line)

    update_lists(ned, deleted_lists_attributes)
  end

  def update_lists(ned, attributes)
    destroy_lists(ned)
    create_items(ned, attributes[:items_ned]) if attributes[:items_ned].present?
    create_planning_items(ned, attributes[:items_planning]) if attributes[:items_planning].present?
    create_disbursement_forecasts(ned, attributes[:items_disbursement_forecast]) if attributes[:items_disbursement_forecast].present?
  end

  def remove_lists_attributes(attributes)
    {
      items_ned: attributes.delete(:lista_itens_ned),
      items_planning: attributes.delete(:lista_itens_planejamento_empenho),
      items_disbursement_forecast: attributes.delete(:lista_previsoes_desembolso)
    }
  end

  def destroy_lists(ned)
    ned.ned_items.delete_all
    ned.ned_planning_items.delete_all
    ned.ned_disbursement_forecasts.delete_all
  end

  def create_items(ned, items)
    list_attributes(items).each do |attributes|
      ned.ned_items << Integration::Expenses::NedItem.create(attributes)
    end
  end

  def create_planning_items(ned, plannning_items)
    list_attributes(plannning_items).each do |attributes|
      ned.ned_planning_items << Integration::Expenses::NedPlanningItem.create(attributes)
    end
  end

  def create_disbursement_forecasts(ned, disbursement_forecasts)
    list_attributes(disbursement_forecasts).each do |attributes|
      ned.ned_disbursement_forecasts << Integration::Expenses::NedDisbursementForecast.create(attributes)
    end
  end

  def years
    month_years.map{|ym| ym[1]}.uniq
  end

  # Define se a estatística é anual
  def stats_yearly?
    true
  end
end
