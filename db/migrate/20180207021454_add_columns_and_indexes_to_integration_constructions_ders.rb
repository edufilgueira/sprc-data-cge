class AddColumnsAndIndexesToIntegrationConstructionsDers < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_ders, :der_status, :integer

    add_index :integration_constructions_ders, :id_obra
    add_index :integration_constructions_ders, :numero_contrato_der
    add_index :integration_constructions_ders, :numero_contrato_sic
    add_index :integration_constructions_ders, :construtora
    add_index :integration_constructions_ders, :distrito
    add_index :integration_constructions_ders, :programa
    add_index :integration_constructions_ders, :supervisora
    add_index :integration_constructions_ders, :status
    add_index :integration_constructions_ders, :der_status
  end
end
