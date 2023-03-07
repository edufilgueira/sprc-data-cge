class AddIndexToIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_creditors, :cpf_cnpj, name: :isc_cpf_cnpj
  end
end
