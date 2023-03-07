require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Supports::Creditor::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationSupportsCreditorImporter perform_async is called' do
      it 'calls IntegrationSupportsCreditorImporter call method' do
        create(:integration_supports_creditor)
        create(:integration_supports_creditor_configuration)

        expect do
          Integration::Supports::Creditor::ImporterWorker.perform_async
          Integration::Supports::Creditor::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end


