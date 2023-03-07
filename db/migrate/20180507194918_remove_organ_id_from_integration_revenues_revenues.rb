class RemoveOrganIdFromIntegrationRevenuesRevenues < ActiveRecord::Migration[5.0]
  def change
    remove_index :integration_revenues_revenues, :organ_id
    remove_column :integration_revenues_revenues, :organ_id, :integer
  end
end
