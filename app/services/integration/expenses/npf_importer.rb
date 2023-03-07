#
# Importador de dados do Web Service de NED
#
class Integration::Expenses::NpfImporter < Integration::Expenses::BaseExpensesImporter

  private

  def model_klass
    Integration::Expenses::Npf
  end

  def create_stats_klass
    Integration::Expenses::Npfs::CreateStats
  end

  def import_npf(attributes, line)
    npf = find_or_initializer(model_klass, attributes)

    update(npf, attributes, line)
  end
end
