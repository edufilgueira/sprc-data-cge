class CreateTransparencyFollowers < ActiveRecord::Migration[5.0]
  def change
    create_table :transparency_followers do |t|
      t.string :email, index: true
      t.integer :resourceable_id
      t.string :resourceable_type
      t.string :transparency_link
      t.datetime :unsubscribed_at, index: true

      t.timestamps
    end

    add_index :transparency_followers, [:resourceable_id, :resourceable_type], name: 'index_t_f_resourceable'
  end
end
