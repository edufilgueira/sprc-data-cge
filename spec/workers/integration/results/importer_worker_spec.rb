require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Results::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Results::Importer perform_async is called' do
      it 'calls Integration::Results::Importer call method' do
        create(:integration_results_configuration)

        expect do
          Integration::Results::ImporterWorker.perform_async
          Integration::Results::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end
