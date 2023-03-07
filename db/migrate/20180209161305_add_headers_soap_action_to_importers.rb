class AddHeadersSoapActionToImporters < ActiveRecord::Migration[5.0]
  def change
    add_column :importers, :headers_soap_action, :string
  end
end
