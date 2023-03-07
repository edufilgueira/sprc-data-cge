require 'rails_helper'
require 'sidekiq/testing'

describe Integration::RealStates::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::RealStates::Importer perform_async is called' do
      it 'calls Integration::RealStates::Importer call method' do
        create(:integration_real_states_configuration)

        expect do
          Integration::RealStates::ImporterWorker.perform_async
          Integration::RealStates::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
