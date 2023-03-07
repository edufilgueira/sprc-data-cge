require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Supports::Domain::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationSupportsDomainImporter perform_async is called' do
      it 'calls IntegrationSupportsDomainImporter call method' do
        create(:integration_supports_domain_configuration)

        expect do
          Integration::Supports::Domain::ImporterWorker.perform_async
          Integration::Supports::Domain::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
