class AddCodigoRegiaoResumidoToIntegrationSupportsAdministrativeRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_administrative_regions, :codigo_regiao_resumido, :string
    add_index :integration_supports_administrative_regions, :codigo_regiao_resumido, name: :isar_codigo_regiao_resumido
  end
end
