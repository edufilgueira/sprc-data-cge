class CreateTransparencyExports < ActiveRecord::Migration[5.0]
  def change
    create_table :transparency_exports do |t|
      t.string :name
      t.string :email
      t.string :query
      t.string :resource_name
      t.string :filename
      t.integer :status
      t.datetime :expiration

      t.timestamps
    end
  end
end
