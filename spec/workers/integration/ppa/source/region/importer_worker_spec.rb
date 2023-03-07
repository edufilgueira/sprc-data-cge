require 'rails_helper'
require 'sidekiq/testing'

describe Integration::PPA::Source::Region::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::PPA::Source::Region::Importer perform_async is called' do
      it 'calls Integration::PPA::Source::Region::Importer call method' do
        create(:integration_ppa_source_region_configuration)

        expect do
          Integration::PPA::Source::Region::ImporterWorker.perform_async
          Integration::PPA::Source::Region::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end
