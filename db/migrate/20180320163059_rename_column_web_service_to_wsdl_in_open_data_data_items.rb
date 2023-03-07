class RenameColumnWebServiceToWsdlInOpenDataDataItems < ActiveRecord::Migration[5.0]
  def change
    rename_column :open_data_data_items, :webservice, :wsdl
  end
end
