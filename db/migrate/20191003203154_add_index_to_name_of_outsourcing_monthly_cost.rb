class AddIndexToNameOfOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_outsourcing_monthly_costs, :nome
  end
end
