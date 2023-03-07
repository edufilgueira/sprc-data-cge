class CreateIntegrationConstructionsDers < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_ders do |t|
      t.string :base
      t.string :cerca
      t.datetime :conclusao
      t.string :construtora
      t.string :cor_status
      t.datetime :data_fim_contrato
      t.datetime :data_fim_previsto
      t.string :distrito
      t.string :drenagem
      t.decimal :extensao
      t.integer :id_obra
      t.string :numero_contrato_der
      t.string :numero_contrato_ext
      t.string :numero_contrato_sic
      t.string :obra_darte
      t.integer :percentual_executado
      t.string :programa
      t.integer :qtd_empregos
      t.integer :qtd_geo_referencias
      t.string :revestimento
      t.string :rodovia
      t.string :servicos
      t.string :sinalizacao
      t.string :status
      t.string :supervisora
      t.string :terraplanagem
      t.string :trecho
      t.datetime :ult_atual
      t.decimal :valor_aprovado

      t.timestamps
    end
  end
end
