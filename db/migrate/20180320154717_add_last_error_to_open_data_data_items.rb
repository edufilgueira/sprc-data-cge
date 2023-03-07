class AddLastErrorToOpenDataDataItems < ActiveRecord::Migration[5.0]
  def change
    add_column :open_data_data_items, :last_error, :text
  end
end
