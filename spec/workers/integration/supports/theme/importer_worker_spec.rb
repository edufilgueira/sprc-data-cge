require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Supports::Theme::ImporterWorker do

  describe 'background job' do
    describe 'when IntegrationSupportsThemeImporter perform_async is called' do
      it 'calls IntegrationSupportsThemeImporter call method' do
        create(:integration_supports_theme_configuration)

        expect do
          Integration::Supports::Theme::ImporterWorker.perform_async
          Integration::Supports::Theme::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
