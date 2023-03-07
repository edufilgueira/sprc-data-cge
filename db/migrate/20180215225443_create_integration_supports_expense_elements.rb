class CreateIntegrationSupportsExpenseElements < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_expense_elements do |t|
      t.string :codigo_elemento_despesa
      t.boolean :eh_elementar
      t.boolean :eh_licitacao
      t.boolean :eh_transferencia
      t.string :titulo
    end
    add_index :integration_supports_expense_elements, :codigo_elemento_despesa, name: :isee_codigo_elemento_despesa
    add_index :integration_supports_expense_elements, :eh_elementar, name: :isee_eh_elementar
    add_index :integration_supports_expense_elements, :eh_licitacao, name: :isee_eh_licitacao
    add_index :integration_supports_expense_elements, :eh_transferencia, name: :isee_eh_transferencia
  end
end
