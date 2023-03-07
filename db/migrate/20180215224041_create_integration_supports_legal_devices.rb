class CreateIntegrationSupportsLegalDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_legal_devices do |t|
      t.string :codigo
      t.text :descricao
    end
    add_index :integration_supports_legal_devices, :codigo, name: :isld_codigo
  end
end
