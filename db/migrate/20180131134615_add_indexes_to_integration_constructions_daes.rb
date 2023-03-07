class AddIndexesToIntegrationConstructionsDaes < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_constructions_daes, :id_obra
    add_index :integration_constructions_daes, :codigo_obra
    add_index :integration_constructions_daes, :contratada
    add_index :integration_constructions_daes, :municipio
    add_index :integration_constructions_daes, :secretaria
    add_index :integration_constructions_daes, :status
    add_index :integration_constructions_daes, :dae_status
  end
end
