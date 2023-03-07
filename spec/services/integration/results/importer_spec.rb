require 'rails_helper'

describe Integration::Results::Importer do

  let(:configuration) { create(:integration_results_configuration) }

  let(:service) { Integration::Results::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Results::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Results::Importer.call(1)

      expect(Integration::Results::Importer).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to configuration' do
      expect(service.configuration).to eq(configuration)
    end
  end

  describe 'call' do

    describe 'error' do
      before do
        allow(service).to receive(:call_strategic_indicator) { raise 'Error' }
        service.call
        configuration.reload
      end

      it { expect(configuration.status_fail?).to be_truthy }
    end

    describe 'success' do
      before do
        allow(service).to receive(:call_strategic_indicator)
        allow(service).to receive(:call_thematic_indicator)
        service.call
        configuration.reload
      end

      it { expect(service).to have_received(:call_strategic_indicator) }
      it { expect(service).to have_received(:call_thematic_indicator) }

      it { expect(configuration.status_success?).to be_truthy }
    end
  end
end
