#
# Cria planilha de despesas - suprimento de fundos
#

class Integration::Expenses::FundSupplies::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :fund_supply
  end

  def resource_klass
    Integration::Expenses::FundSupply
  end

  # override
  def resources
    resource_klass.from_executivo.from_year(year).ordinarias
  end

  def file_name_prefix
    :suprimento_fundos
  end

  def presenter_klass
    Integration::Expenses::FundSupply::SpreadsheetPresenter
  end
end
