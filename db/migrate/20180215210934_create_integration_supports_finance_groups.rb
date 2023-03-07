class CreateIntegrationSupportsFinanceGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_finance_groups do |t|
      t.string :codigo_grupo_financeiro
      t.string :titulo
    end
    add_index :integration_supports_finance_groups, :codigo_grupo_financeiro, name: :isfg_codigo_grupo_financeiro
  end
end
