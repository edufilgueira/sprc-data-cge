class AddIndexToIntegrationSupportsUndertakingsDescricao < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_undertakings, :descricao
  end
end
