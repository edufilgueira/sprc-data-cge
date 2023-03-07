class AddIndexCompetenciaToIntegrationOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_outsourcing_monthly_costs, :competencia
  end
end
