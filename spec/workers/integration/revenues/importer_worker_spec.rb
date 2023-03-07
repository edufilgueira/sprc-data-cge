require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Revenues::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Revenues::Importer perform_async is called' do
      it 'calls Integration::Revenues::Importer call method' do
        create(:integration_revenues_configuration)

        expect do
          Integration::Revenues::ImporterWorker.perform_async
          Integration::Revenues::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
