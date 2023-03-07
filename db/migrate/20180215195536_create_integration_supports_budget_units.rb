class CreateIntegrationSupportsBudgetUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_budget_units do |t|
      t.string :codigo_unidade_gestora
      t.string :codigo_unidade_orcamentaria
      t.string :titulo
    end
    add_index :integration_supports_budget_units, :codigo_unidade_gestora, name: :isbu_codigo_unidade_gestora
    add_index :integration_supports_budget_units, :codigo_unidade_orcamentaria, name: :isbu_codigo_unidade_orcamentaria
  end
end
