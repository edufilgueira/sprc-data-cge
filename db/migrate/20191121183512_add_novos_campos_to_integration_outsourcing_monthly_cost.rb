class AddNovosCamposToIntegrationOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_outsourcing_monthly_costs, :vlr_adicional, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_adicional_noturno, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_reserva_tecnica, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_encargos, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_taxa, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_cesta_basica, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_farda, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_municao, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_seguro_vida, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_supervisao, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_insalubridade, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_periculosidade, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_equipamento, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_tributos, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_total_montante, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_dsr, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_extra_encargos, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_extra_taxa, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_extra_tributos, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_total_extra, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_passagem, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_viagem, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_viagem_taxa, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_viagem_tributos, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_total_viagem, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_plano_saude, :decimal
    add_column :integration_outsourcing_monthly_costs, :vlr_outros, :decimal
  end
end
