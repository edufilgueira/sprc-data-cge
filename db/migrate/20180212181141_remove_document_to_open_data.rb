class RemoveDocumentToOpenData < ActiveRecord::Migration[5.0]
  def change
    remove_column :open_data, :document_id, :string
  end
end
