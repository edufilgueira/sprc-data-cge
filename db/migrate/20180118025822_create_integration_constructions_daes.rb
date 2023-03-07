class CreateIntegrationConstructionsDaes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_daes do |t|
      t.integer :id_obra
      t.string :codigo_obra
      t.string :contratada
      t.datetime :data_fim_previsto
      t.datetime :data_inicio
      t.datetime :data_ordem_servico
      t.string :descricao
      t.integer :dias_aditivado
      t.string :latitude
      t.string :longitude
      t.string :municipio
      t.string :numero_licitacao
      t.string :numero_ordem_servico
      t.string :numero_sacc
      t.decimal :percentual_executado
      t.integer :prazo_inicial
      t.string :secretaria
      t.string :status
      t.string :tipo_contrato
      t.decimal :valor

      t.timestamps
    end
  end
end
