#
# Importador de dados do Web Service de NPD
#
class Integration::Expenses::NpdImporter < Integration::Expenses::BaseExpensesImporter

  private

  def model_klass
    Integration::Expenses::Npd
  end

  def create_stats_klass
    Integration::Expenses::Npds::CreateStats
  end

  def import_npd(attributes, line)
    npd = find_or_initializer(Integration::Expenses::Npd, attributes)

    update(npd, attributes, line)
  end
end
