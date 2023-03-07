require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Supports::Organ::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationSupportsOrganImporter perform_async is called' do
      it 'calls IntegrationSupportsOrganImporter call method' do
        create(:integration_supports_organ_configuration)

        expect do
          Integration::Supports::Organ::ImporterWorker.perform_async
          Integration::Supports::Organ::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
