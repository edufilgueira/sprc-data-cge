class FixPPASourceGuidelinesUniquenessIndex < ActiveRecord::Migration[5.0]
  def up
      # t.index ["codigo_regiao", "codigo_ppa_objetivo_estrategico", "codigo_ppa_estrategia", "codigo_eixo", "codigo_tema", "codigo_ppa_iniciativa", "codigo_produto", "descricao_referencia", "ano"], name: "index_ppa_source_guidelines_uniqueness", unique: true, using: :btree
      remove_index :ppa_source_guidelines, name: "index_ppa_source_guidelines_uniqueness"

      add_index :ppa_source_guidelines, %w[
        ano
        codigo_regiao
        codigo_eixo
        codigo_tema
        codigo_ppa_objetivo_estrategico
        codigo_ppa_estrategia
        codigo_programa
        codigo_ppa_iniciativa
        codigo_acao
        codigo_produto
        descricao_referencia
      ], name: 'index_ppa_source_guidelines_uniqueness',
         unique: true

  end

  def down
    remove_index :ppa_source_guidelines, name: "index_ppa_source_guidelines_uniqueness"

    add_index :ppa_source_guidelines, %w[
      codigo_regiao
      codigo_ppa_objetivo_estrategico
      codigo_ppa_estrategia
      codigo_eixo
      codigo_tema
      codigo_ppa_iniciativa
      codigo_produto
      descricao_referencia
      ano
    ], name: "index_ppa_source_guidelines_uniqueness",
       unique: true
  end
end
