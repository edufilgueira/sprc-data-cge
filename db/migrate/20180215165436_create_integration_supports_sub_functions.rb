class CreateIntegrationSupportsSubFunctions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_sub_functions do |t|
      t.string :codigo_sub_funcao
      t.string :titulo
    end
    add_index :integration_supports_sub_functions, :codigo_sub_funcao, name: :issf_codigo_sub_funcao
  end
end
