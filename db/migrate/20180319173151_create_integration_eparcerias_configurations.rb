class CreateIntegrationEparceriasConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_eparcerias_configurations do |t|
      t.string :wsdl
      t.string :user
      t.string :password
      t.string :operation
      t.string :response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log
      t.string :headers_soap_action
      t.integer :import_type
      t.string :transfer_bank_order_operation
      t.string :transfer_bank_order_response_path
      t.string :work_plan_attachement_operation
      t.string :work_plan_attachement_response_path
      t.string :accountability_operation
      t.string :accountability_response_path
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
