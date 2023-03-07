class CreateIntegrationSupportsManagementUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_management_units do |t|
      t.string :cgf
      t.string :cnpj
      t.string :codigo
      t.string :codigo_credor
      t.string :poder
      t.string :sigla
      t.string :tipo_administracao
      t.string :tipo_de_ug
      t.string :titulo
    end
    add_index :integration_supports_management_units, :cgf, name: :ismu_cgf
    add_index :integration_supports_management_units, :cnpj, name: :ismu_cnpj
    add_index :integration_supports_management_units, :codigo, name: :ismu_codigo
    add_index :integration_supports_management_units, :codigo_credor, name: :ismu_codigo_credor
    add_index :integration_supports_management_units, :poder, name: :ismu_poder
    add_index :integration_supports_management_units, :sigla, name: :ismu_sigla
    add_index :integration_supports_management_units, :tipo_administracao, name: :ismu_tipo_administracao
    add_index :integration_supports_management_units, :tipo_de_ug, name: :ismu_tipo_de_ug
  end
end
