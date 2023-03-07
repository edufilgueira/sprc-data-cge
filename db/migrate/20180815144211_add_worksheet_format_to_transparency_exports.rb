class AddWorksheetFormatToTransparencyExports < ActiveRecord::Migration[5.0]
  def change
    add_column :transparency_exports, :worksheet_format, :integer
  end
end
