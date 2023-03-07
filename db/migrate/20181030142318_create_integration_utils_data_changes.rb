class CreateIntegrationUtilsDataChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_utils_data_changes do |t|
      t.jsonb :data_changes
      t.integer :changeable_id
      t.string :changeable_type
      t.integer :resource_status, default: 0

      t.timestamps
    end

    add_index :integration_utils_data_changes, [:resource_status]
    add_index :integration_utils_data_changes, [:changeable_id, :changeable_type], name: 'index_i_u_dc_changeable'
    add_index :integration_utils_data_changes, [:resource_status, :changeable_id, :changeable_type], name: 'index_i_u_dc_resource_status_changeable'
  end
end
