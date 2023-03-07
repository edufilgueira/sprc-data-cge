class CreatePPASourceAxisThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_source_axis_themes do |t|
      t.string :codigo_eixo, index: true
      t.string :descricao_eixo
      t.string :codigo_tema, index: true
      t.string :descricao_tema
      t.string :descricao_tema_detalhado

      t.timestamps
    end

    add_index :ppa_source_axis_themes, %i[codigo_eixo codigo_tema], unique: true
  end
end
