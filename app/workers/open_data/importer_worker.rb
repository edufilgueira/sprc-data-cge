class OpenData::ImporterWorker
  include Sidekiq::Worker

  def perform
    OpenData::DataItem.webservice.pluck(:id).each do |data_item_id|
      Integration::Importers::Import.call(:open_data, data_item_id)
    end
  end
end
