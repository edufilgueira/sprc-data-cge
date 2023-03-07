class AddFieldsToIntegrationConstructionsDers < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_ders, :data_inicio_obra, :datetime
    add_column :integration_constructions_ders, :data_ordem_servico, :datetime
    add_column :integration_constructions_ders, :dias_adicionado, :integer
    add_column :integration_constructions_ders, :dias_suspenso, :integer
    add_column :integration_constructions_ders, :municipio, :string
    add_column :integration_constructions_ders, :numero_ordem_servico, :string
    add_column :integration_constructions_ders, :prazo_inicial, :integer
    add_column :integration_constructions_ders, :total_aditivo, :decimal
    add_column :integration_constructions_ders, :total_reajuste, :decimal
    add_column :integration_constructions_ders, :valor_atual, :decimal
    add_column :integration_constructions_ders, :valor_original, :decimal
    add_column :integration_constructions_ders, :valor_pi, :decimal
  end
end
