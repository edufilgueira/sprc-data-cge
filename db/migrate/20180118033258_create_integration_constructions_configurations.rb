class CreateIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_configurations do |t|
      t.string :headers_soap_action
      t.string :user
      t.string :password
      t.string :der_wsdl
      t.string :dae_wsdl
      t.string :der_operation
      t.string :der_response_path
      t.string :dae_operation
      t.string :dae_response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log

      t.timestamps
    end
  end
end
