class ChangeSicToIntegrationCityUndertakingsCityUndertakings < ActiveRecord::Migration[5.0]
  def up
    change_column(:integration_city_undertakings_city_undertakings, :sic, 'integer USING CAST(sic AS integer)')
  end

  def down
    change_column(:integration_city_undertakings_city_undertakings, :sic, :string)
  end
end
