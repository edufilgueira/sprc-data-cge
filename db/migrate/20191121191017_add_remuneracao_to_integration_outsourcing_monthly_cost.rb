class AddRemuneracaoToIntegrationOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_outsourcing_monthly_costs, :remuneracao, :decimal
  end
end
