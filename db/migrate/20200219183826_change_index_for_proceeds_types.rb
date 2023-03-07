class ChangeIndexForProceedsTypes < ActiveRecord::Migration[5.0]
  def up

    remove_index :integration_servers_proceed_types, name: "index_integration_servers_proceed_types_on_dsc_tipo"
    add_index :integration_servers_proceed_types, 'upper(dsc_tipo)', name: "index_integration_servers_proceed_types_on_dsc_tipo"

  end

  def down
    remove_index :integration_servers_proceed_types, name: "index_integration_servers_proceed_types_on_dsc_tipo"
    add_index :integration_servers_proceed_types, [:dsc_tipo], name: "index_integration_servers_proceed_types_on_dsc_tipo"

  end
end
