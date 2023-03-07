class CreateOpenDataDataSets < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data_data_sets do |t|
      t.string :title
      t.text :description
      t.string :source_catalog
      t.integer :organ_id
      t.string :author
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :open_data_data_sets, :organ_id
  end
end
