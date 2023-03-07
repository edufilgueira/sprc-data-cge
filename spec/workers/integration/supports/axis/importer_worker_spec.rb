require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Supports::Axis::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationSupportsAxisImporter perform_async is called' do
      it 'calls IntegrationSupportsAxisImporter call method' do
        create(:integration_supports_axis_configuration)

        expect do
          Integration::Supports::Axis::ImporterWorker.perform_async
          Integration::Supports::Axis::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
