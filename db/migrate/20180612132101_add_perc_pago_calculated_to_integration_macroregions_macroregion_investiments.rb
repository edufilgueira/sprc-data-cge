class AddPercPagoCalculatedToIntegrationMacroregionsMacroregionInvestiments < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_macroregions_macroregion_investiments, :perc_pago_calculated, :decimal
  end
end
