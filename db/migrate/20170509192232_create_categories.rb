class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, index: true
      t.string :icon_id
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
