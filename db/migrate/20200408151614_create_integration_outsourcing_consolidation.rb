class CreateIntegrationOutsourcingConsolidation < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_outsourcing_consolidations do |t|
      t.string :mes
      t.integer :qde_terc_alocados
      t.decimal :vlr_custo
      t.decimal :vlr_remuneracao
      t.decimal :vlr_encargos_taxas
      t.integer :month
      t.integer :year
      t.timestamps
    end

    add_index :integration_outsourcing_consolidations, :month
    add_index :integration_outsourcing_consolidations, :year
    add_index :integration_outsourcing_consolidations, [:year, :month]
    add_index :integration_outsourcing_consolidations, :mes
  end
end


