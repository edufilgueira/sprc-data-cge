class RemoveMonthFromIntegrationOutsourcingEntities < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_outsourcing_entities, :month_import
  end
end
