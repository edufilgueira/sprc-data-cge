class AddAccountTypeToIntegrationRevenuesRevenues < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_revenues, :account_type, :integer
    add_index :integration_revenues_revenues, :account_type, name: :irr_account_type
  end
end
