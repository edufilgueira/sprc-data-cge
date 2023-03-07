class RenameTableIntegrationContractsTransferBankOrdersToIntegrationEparceriasTransferBankOrders < ActiveRecord::Migration[5.0]
  def change
    rename_table :integration_contracts_transfer_bank_orders, :integration_eparcerias_transfer_bank_orders
  end
end
