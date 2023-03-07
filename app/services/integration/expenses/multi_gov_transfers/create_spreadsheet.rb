#
# Cria planilha de despesas
#

class Integration::Expenses::MultiGovTransfers::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :multi_gov_transfer
  end

  def resource_klass
    Integration::Expenses::MultiGovTransfer
  end

  def file_name_prefix
    :transferencias_instituicoes_multigovernamentais
  end

  def presenter_klass
    Integration::Expenses::MultiGovTransfer::SpreadsheetPresenter
  end
end
