class AddIndexToServerSalary < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_server_salaries, :functional_status
    add_index :integration_servers_server_salaries, :cod_situacao_funcional, name: "index_for_server_salaries_cod_sit_fun"
    add_index :integration_servers_server_salaries, :status_situacao_funcional, name: "index_for_server_salaries_sit_fun"
    add_index :integration_servers_server_salaries, [:date, :functional_status], name: "index_for_server_salaries_date_func_stat"
  end
end
