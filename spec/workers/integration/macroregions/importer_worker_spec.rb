require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Macroregions::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Macroregions::Importer perform_async is called' do
      it 'calls Integration::Macroregions::Importer call method' do
        create(:integration_macroregions_configuration)

        expect do
          Integration::Macroregions::ImporterWorker.perform_async
          Integration::Macroregions::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end
