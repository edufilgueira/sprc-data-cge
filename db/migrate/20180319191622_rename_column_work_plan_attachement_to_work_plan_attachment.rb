class RenameColumnWorkPlanAttachementToWorkPlanAttachment < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_eparcerias_configurations, :work_plan_attachement_operation, :work_plan_attachment_operation
    rename_column :integration_eparcerias_configurations, :work_plan_attachement_response_path, :work_plan_attachment_response_path
  end
end
