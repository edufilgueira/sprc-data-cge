class CreateOpenDataVcgeCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data_vcge_categories do |t|
      t.string :title
      t.string :href
      t.string :name
      t.string :vcge_id
    end
    add_index :open_data_vcge_categories, :vcge_id
  end
end
