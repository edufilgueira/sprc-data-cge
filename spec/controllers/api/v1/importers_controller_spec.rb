require 'rails_helper'

describe Api::V1::ImportersController do

  describe '#create'  do
    describe 'importers' do

      let(:configuration) { create("integration_#{configuration_id}_configuration") }

      let(:params) do
        { id: configuration_id, configuration_id: configuration.id }
      end

      before do
        expect_any_instance_of(configuration.class).to receive(:import)
        post(:create, params: params)
      end

      after do
        configuration.reload
        expect(configuration).to be_status_queued
      end

      describe 'servers' do
        let(:configuration_id) { :servers }

        it 'calls configuration.import' do
        end
      end

      describe 'contracts' do
        let(:configuration_id) { :contracts }

        it 'calls configuration.import' do
        end
      end

      describe 'constructions' do
        let(:configuration_id) { :constructions }

        it 'calls configuration.import' do
        end
      end

      describe 'purchases' do
        let(:configuration_id) { :purchases }

        it 'calls configuration.import' do
        end
      end

      describe 'eparcerias' do
        let(:configuration_id) { :eparcerias }

        it 'calls configuration.import' do
        end
      end

      describe 'contracts' do
        let(:configuration_id) { :contracts }

        it 'calls configuration.import' do
        end
      end

      describe 'expenses' do
        let(:configuration_id) { :expenses }

        it 'calls configuration.import' do
        end
      end

      describe 'revenues' do
        let(:configuration_id) { :revenues }

        it 'calls configuration.import' do
        end
      end

      describe 'supports_organ' do
        let(:configuration_id) { :supports_organ }

        it 'calls configuration.import' do
        end
      end

      describe 'supports_creditor' do
        let(:configuration_id) { :supports_creditor }

        it 'calls configuration.import' do
        end
      end

      describe 'open_data' do
        let(:configuration) { create(:data_item) }

        let(:configuration_id) { :open_data }

        it 'calls configuration.import' do
        end
      end
    end
  end
end
