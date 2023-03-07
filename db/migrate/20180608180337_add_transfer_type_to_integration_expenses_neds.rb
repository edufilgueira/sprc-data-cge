class AddTransferTypeToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :transfer_type, :integer
    add_index :integration_expenses_neds, :transfer_type, name: :ien_transfer_type
  end
end
