require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Constructions::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationConstructionsImporter perform_async is called' do
      it 'calls IntegrationConstructionsImporter call method' do
        create(:integration_constructions_configuration)

        expect do
          Integration::Constructions::ImporterWorker.perform_async
          Integration::Constructions::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
