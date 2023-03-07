class CreateIntegrationOutsourcingConfiguration < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_outsourcing_configurations do |t|
      t.string :wsdl
      t.string :headers_soap_action
      t.string :user
      t.string :password
      t.string :entity_operation
      t.string :entity_response_path
      t.string :monthly_cost_operation
      t.string :monthly_cost_response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log
      t.string :month

      t.timestamps
    end
  end
end
