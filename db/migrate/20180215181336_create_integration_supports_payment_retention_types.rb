class CreateIntegrationSupportsPaymentRetentionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_payment_retention_types do |t|
      t.string :codigo_retencao
      t.string :titulo
    end
    add_index :integration_supports_payment_retention_types, :codigo_retencao, name: :isprt_codigo_retencao
  end
end
