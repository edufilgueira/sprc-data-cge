class DropImporters < ActiveRecord::Migration[5.0]
  def change
    drop_table :importers
  end
end
