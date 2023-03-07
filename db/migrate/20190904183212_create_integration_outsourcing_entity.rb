class CreateIntegrationOutsourcingEntity < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_outsourcing_entities do |t|
      t.integer :isn_entidade
      t.string :dsc_sigla
      t.string :dsc_entidade
      t.string :month_import
      t.timestamps
    end

    add_index :integration_outsourcing_entities, :isn_entidade
    add_index :integration_outsourcing_entities, :month_import
  end
end
