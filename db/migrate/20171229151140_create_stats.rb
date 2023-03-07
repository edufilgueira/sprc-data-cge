class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.string :type
      t.integer :month
      t.integer :year
      t.text :data

      t.timestamps
    end
    add_index :stats, :type
    add_index :stats, :month
    add_index :stats, :year
  end
end
