class AddIndexRegistrationImport < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_registrations, [:dsc_matricula, :cod_orgao], name: "index_for_import_process_dsc_matricula_cod_orgao"
  end
end
