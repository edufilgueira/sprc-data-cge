class CreateIntegrationSupportsExpenseNatureGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_expense_nature_groups do |t|
      t.string :codigo_grupo_natureza
      t.string :titulo
    end
    add_index :integration_supports_expense_nature_groups, :codigo_grupo_natureza, name: :iseng_codigo_grupo_natureza
  end
end
