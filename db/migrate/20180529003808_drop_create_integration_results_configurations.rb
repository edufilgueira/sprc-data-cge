class DropCreateIntegrationResultsConfigurations < ActiveRecord::Migration[5.0]
  def change

    # old table - reversible
    drop_table :integration_results_configurations do |t|
      t.string :wsdl
      t.string :user
      t.string :password
      t.string :operation
      t.string :response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log
      t.string :headers_soap_action

      t.timestamps
    end

    # new table
    create_table :integration_results_configurations do |t|
      t.string :wsdl

      t.string :user
      t.string :password

      t.string :strategic_indicator_response_path
      t.string :strategic_indicator_operation
      t.string :thematic_indicator_response_path
      t.string :thematic_indicator_operation

      t.integer :status
      t.datetime :last_importation
      t.text :log
      t.string :headers_soap_action

      t.timestamps
    end
  end
end
