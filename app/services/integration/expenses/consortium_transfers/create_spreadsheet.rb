#
# Cria planilha de despesas
#

class Integration::Expenses::ConsortiumTransfers::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :consortium_transfer
  end

  def resource_klass
    Integration::Expenses::ConsortiumTransfer
  end

  def file_name_prefix
    :transferencias_consorcios_publicos
  end

  def presenter_klass
    Integration::Expenses::ConsortiumTransfer::SpreadsheetPresenter
  end
end
