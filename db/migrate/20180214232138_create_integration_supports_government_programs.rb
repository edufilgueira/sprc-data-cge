class CreateIntegrationSupportsGovernmentPrograms < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_government_programs do |t|
      t.integer :ano_inicio
      t.string :codigo_programa
      t.string :titulo
    end
    add_index :integration_supports_government_programs, :ano_inicio, name: :isgp_ano_inicio
    add_index :integration_supports_government_programs, :codigo_programa, name: :isgp_codigo_programa
  end
end
