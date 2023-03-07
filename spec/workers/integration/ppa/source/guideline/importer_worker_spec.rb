require 'rails_helper'
require 'sidekiq/testing'

describe Integration::PPA::Source::Guideline::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::PPA::Source::Guideline::Importer perform_async is called' do
      it 'calls Integration::PPA::Source::Guideline::Importer call method' do
        create(:integration_ppa_source_guideline_configuration)

        expect do
          Integration::PPA::Source::Guideline::ImporterWorker.perform_async
          Integration::PPA::Source::Guideline::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end
