class AddDatesToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_organs, :data_inicio, :date
    add_index :integration_supports_organs, :data_inicio, name: :iso_data_inicio

    add_column :integration_supports_organs, :data_termino, :date
    add_index :integration_supports_organs, :data_termino, name: :iso_data_termino

    add_column :integration_supports_organs, :secretary, :boolean
    add_index :integration_supports_organs, :secretary, name: :iso_secretary
  end
end
