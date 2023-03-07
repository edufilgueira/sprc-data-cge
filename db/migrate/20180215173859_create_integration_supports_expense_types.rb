class CreateIntegrationSupportsExpenseTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_expense_types do |t|
      t.string :codigo
    end
    add_index :integration_supports_expense_types, :codigo, name: :iset_codigo
  end
end
