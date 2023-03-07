class CreateIntegrationPPAAxisThemeObjectiveStrategy < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_ppa_source_axis_theme_objective_strategy do |t|
      t.string :ppa_ano_inicio
      t.string :ppa_ano_fim
      t.string :eixo_cod
      t.text :eixo_descricao
      t.string :regiao_cod
      t.string :regiao_descricao
      t.string :tema_cod
      t.text :tema_descricao
      t.string :objetivo_cod
      t.text :objetivo_descricao
      t.string :estrategia_cod
      t.text :estrategia_descricao
    end
  end
end

