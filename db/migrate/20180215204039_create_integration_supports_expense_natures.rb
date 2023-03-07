class CreateIntegrationSupportsExpenseNatures < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_expense_natures do |t|
      t.string :codigo_natureza_despesa
      t.string :titulo
    end
    add_index :integration_supports_expense_natures, :codigo_natureza_despesa, name: :isen_codigo_natureza_despesa
  end
end
