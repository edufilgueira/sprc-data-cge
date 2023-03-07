class CreateOpenDataVcgeCategoryAssociations < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data_vcge_category_associations do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    add_index :open_data_vcge_category_associations, :parent_id
    add_index :open_data_vcge_category_associations, :child_id
  end
end
