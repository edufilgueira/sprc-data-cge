class ChangeVlrCargaHorariaToDecimal < ActiveRecord::Migration[5.0]
  def up
    change_column :integration_servers_registrations, :vlr_carga_horaria, 'decimal(5,2) USING CAST(vlr_carga_horaria AS decimal(5,2))'
  end

  def down
    change_column :integration_servers_registrations, :vlr_carga_horaria, :integer
  end
end
