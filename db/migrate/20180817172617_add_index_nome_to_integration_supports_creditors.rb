class AddIndexNomeToIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_creditors, :nome
  end
end
