class AddCodigoWithoutZeroesToIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_creditors, :codigo_without_zeroes, :string
    add_index :integration_supports_creditors, :codigo_without_zeroes, name: :isc_codigo_without_zeroes
  end
end
