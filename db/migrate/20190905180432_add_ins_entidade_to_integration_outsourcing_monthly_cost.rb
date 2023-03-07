class AddInsEntidadeToIntegrationOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_outsourcing_monthly_costs, :isn_entidade, :integer
    add_index :integration_outsourcing_monthly_costs, :isn_entidade
  end
end
