class CreateIntegrationMacroregionsRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_macroregions_regions do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
