class CreateIntegrationMacroregionsMacroregionInvestiments < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_macroregions_macroregion_investiments do |t|
      t.string :ano_exercicio
      t.string :codigo_poder
      t.string :descricao_poder
      t.string :codigo_regiao
      t.string :descricao_regiao
      t.decimal :valor_lei
      t.decimal :valor_lei_creditos
      t.decimal :valor_empenhado
      t.decimal :valor_pago
      t.decimal :perc_empenho
      t.decimal :perc_pago

      t.references :power, foreign_key: { to_table: :integration_macroregions_powers }, index: { name: 'index_integration_mr_mi_on_powers_id' }
      t.references :region, foreign_key: { to_table: :integration_macroregions_regions }, index: { name: 'index_integration_mr_mi_on_regions_id' }

      t.timestamps
    end

    add_index :integration_macroregions_macroregion_investiments, [:ano_exercicio, :codigo_poder, :codigo_regiao], unique: true, name: :immi_index_primary
  end
end
