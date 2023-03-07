class RemoveContractsAssociationColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_contracts_contracts, :manager_id, :integer
    remove_column :integration_contracts_contracts, :grantor_id, :integer
    remove_column :integration_contracts_contracts, :creditor_id, :integer

    remove_column :integration_contracts_additives, :integration_contracts_contract_id, :integer
    remove_column :integration_contracts_adjustments, :integration_contracts_contract_id, :integer
    remove_column :integration_contracts_financials, :integration_contracts_contract_id, :integer
    remove_column :integration_contracts_infringements, :integration_contracts_contract_id, :integer
  end
end
