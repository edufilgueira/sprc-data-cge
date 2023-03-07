require 'rails_helper'
require 'sidekiq/testing'

describe Integration::PPA::Source::AxisTheme::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::PPA::Source::AxisTheme::Importer perform_async is called' do
      it 'calls Integration::PPA::Source::AxisTheme::Importer call method' do
        create(:integration_ppa_source_axis_theme_configuration)

        expect do
          Integration::PPA::Source::AxisTheme::ImporterWorker.perform_async
          Integration::PPA::Source::AxisTheme::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end
    end
  end
end
