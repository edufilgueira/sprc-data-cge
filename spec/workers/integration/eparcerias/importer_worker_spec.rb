require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Eparcerias::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Eparcerias::Importer perform_async is called' do
      it 'calls Integration::Eparcerias::Importer call method' do
        create(:integration_eparcerias_configuration)

        expect do
          Integration::Eparcerias::ImporterWorker.perform_async
          Integration::Eparcerias::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
