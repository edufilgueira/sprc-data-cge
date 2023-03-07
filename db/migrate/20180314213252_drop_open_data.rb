class DropOpenData < ActiveRecord::Migration[5.0]
  def change
    drop_table :open_data
  end
end
