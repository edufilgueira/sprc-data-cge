class CreateIntegrationSupportsFunctions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_functions do |t|
      t.string :codigo_funcao
      t.string :titulo
    end
    add_index :integration_supports_functions, :codigo_funcao, name: :isf_codigo_funcao
  end
end
