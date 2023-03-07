#
# Cria planilha de despesas
#

class Integration::Expenses::CityTransfers::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :city_transfer
  end

  def resource_klass
    Integration::Expenses::CityTransfer
  end

  def file_name_prefix
    :transferencias_municipios
  end

  def presenter_klass
    Integration::Expenses::CityTransfer::SpreadsheetPresenter
  end
end
