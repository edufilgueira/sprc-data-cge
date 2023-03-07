require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Expenses::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Expenses::Importer perform_async is called' do
      it 'calls Integration::Expenses::Importer call method' do
        create(:integration_expenses_configuration)

        expect do
          Integration::Expenses::ImporterWorker.perform_async
          Integration::Expenses::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
