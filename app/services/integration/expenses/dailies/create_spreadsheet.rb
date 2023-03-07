#
# Cria planilha de despesas
#

class Integration::Expenses::Dailies::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :daily
  end

  def resource_klass
    Integration::Expenses::Daily
  end

  def file_name_prefix
    :diarias
  end

  def presenter_klass
    Integration::Expenses::Daily::SpreadsheetPresenter
  end

  def resources
    resource_klass.from_executivo.ordinarias.from_year(year)
  end
end
