class CreateIntegrationCityUndertakingsConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_city_undertakings_configurations do |t|
      t.string :wsdl
      t.string :user
      t.string :password
      t.string :undertaking_operation
      t.string :undertaking_response_path
      t.string :city_undertaking_operation
      t.string :city_undertaking_response_path
      t.string :city_organ_operation
      t.string :city_organ_response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log
      t.string :headers_soap_action

      t.timestamps
    end
  end
end
