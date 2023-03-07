require 'rails_helper'
require 'sidekiq/testing'

describe Integration::Servers::ImporterWorker do

  describe 'background job' do
    describe 'when Integration::Servers::Importer perform_async is called' do
      it 'calls Integration::Servers::Importer call method' do
        create_list(:integration_servers_configuration, 2)

        expect do
          Integration::Servers::ImporterWorker.perform_async
          Integration::Servers::ImporterWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end

