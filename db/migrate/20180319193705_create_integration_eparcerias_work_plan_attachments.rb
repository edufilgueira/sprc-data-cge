class CreateIntegrationEparceriasWorkPlanAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_eparcerias_work_plan_attachments do |t|
      t.string :file_name
      t.string :file_type
      t.integer :file_size
      t.text :description
      t.integer :isn_sic
    end
    add_index :integration_eparcerias_work_plan_attachments, :isn_sic, name: :iewpa_isn_sic
  end
end
