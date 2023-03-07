class CreateIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_server_salaries do |t|
      t.integer :year
      t.integer :month
      t.integer :integration_servers_registration_id
      t.string :role

      t.decimal :income_total, precision: 10, scale: 2
      t.decimal :income_final, precision: 10, scale: 2
      t.decimal :income_diaries, precision: 10, scale: 2

      t.decimal :discount_total, precision: 10, scale: 2
      t.decimal :discount_under_roof, precision: 10, scale: 2
      t.decimal :discount_others, precision: 10, scale: 2

      t.timestamps
    end

    add_index :integration_servers_server_salaries, :year
    add_index :integration_servers_server_salaries, :month
    add_index :integration_servers_server_salaries, :integration_servers_registration_id, name: :isss_registration_id
    add_index :integration_servers_server_salaries, :role
  end
end
