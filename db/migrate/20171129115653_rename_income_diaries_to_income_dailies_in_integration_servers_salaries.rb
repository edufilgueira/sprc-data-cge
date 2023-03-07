class RenameIncomeDiariesToIncomeDailiesInIntegrationServersSalaries < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_servers_server_salaries, :income_diaries, :income_dailies
  end
end
