require 'rails_helper'
require 'sidekiq/testing'

describe OpenData::ImporterWorker do

  describe 'background job' do
    describe 'when OpenData::ImporterWorker perform_async is called' do
      before do
        response = double()
        allow_any_instance_of(Savon::Client).to receive(:call) { response }
        allow(response).to receive(:body) { { '1': 2 } }
      end

      it 'calls OpenData::Importer call method' do
        create(:data_item, :webservice)
        create(:data_item, :webservice)
        create(:data_item, :file)

        expect do
          OpenData::ImporterWorker.perform_async
          OpenData::ImporterWorker.drain

          # Deve invocar um job para cada data_item do tipo webservice
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(OpenData::DataItem.webservice.count)
      end

    end
  end
end
