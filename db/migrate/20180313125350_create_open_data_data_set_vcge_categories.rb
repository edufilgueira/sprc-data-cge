class CreateOpenDataDataSetVcgeCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data_data_set_vcge_categories do |t|
      t.integer :open_data_data_set_id
      t.integer :open_data_vcge_category_id
    end
    add_index :open_data_data_set_vcge_categories, :open_data_data_set_id, name: :odds_open_data_set_id
    add_index :open_data_data_set_vcge_categories, :open_data_vcge_category_id, name: :odds_vcge_category_id
  end
end
