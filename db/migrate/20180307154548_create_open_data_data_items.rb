class CreateOpenDataDataItems < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data_data_items do |t|
      t.string :title
      t.text :description
      t.integer :data_item_type
      t.integer :open_data_data_set_id
      t.string :response_path
      t.string :webservice
      t.string :operation
      t.string :parameters
      t.string :headers_soap_action
      t.integer :status
      t.string :document_public_filename
      t.string :document_format
      t.string :document_id
      t.string :document_filename
      t.string :document_content_size
      t.string :document_content_type
      t.datetime :processed_at
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :open_data_data_items, :data_item_type, name: :oddi_data_item_type
    add_index :open_data_data_items, :open_data_data_set_id, name: :oddi_open_data_data_set_id
    add_index :open_data_data_items, :status, name: :oddi_status
  end
end
