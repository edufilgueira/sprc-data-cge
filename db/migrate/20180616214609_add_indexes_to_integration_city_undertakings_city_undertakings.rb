class AddIndexesToIntegrationCityUndertakingsCityUndertakings < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_city_undertakings_city_undertakings, :municipio, name: 'city_undertakings_by_municipio'
    add_index :integration_city_undertakings_city_undertakings, :mapp, name: 'city_undertakings_by_mapp'
    add_index :integration_city_undertakings_city_undertakings, :sic, name: 'city_undertakings_by_sic'
    add_index :integration_city_undertakings_city_undertakings, [:municipio, :mapp, :sic, :undertaking_id], name: 'city_undertakings_by_finder'
  end
end
