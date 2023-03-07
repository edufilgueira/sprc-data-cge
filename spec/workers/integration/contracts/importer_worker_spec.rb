require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Contracts::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Contracts::Importer perform_async is called' do
      it 'calls Integration::Contracts::Importer call method' do
        create(:integration_contracts_configuration)

        expect do
          Integration::Contracts::ImporterWorker.perform_async
          Integration::Contracts::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
