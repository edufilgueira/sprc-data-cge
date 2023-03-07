class CreateIntegrationSupportsAdministrativeRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_administrative_regions do |t|
      t.string :codigo_regiao
      t.string :titulo
    end
    add_index :integration_supports_administrative_regions, :codigo_regiao, name: :isar_codigo_regiao
  end
end
