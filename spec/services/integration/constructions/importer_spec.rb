require 'rails_helper'

describe Integration::Constructions::Importer do

  let(:configuration) { create(:integration_constructions_configuration) }

  let(:service) { Integration::Constructions::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Constructions::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Constructions::Importer.call(1)

      expect(Integration::Constructions::Importer).to have_received(:new).with(1)
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
        allow(service).to receive(:call_der) { raise 'Error' }
        service.call
        configuration.reload
      end

      it { expect(configuration.status_fail?).to be_truthy }

    end

    describe 'success' do

      before do
        allow(service).to receive(:call_der)
        allow(service).to receive(:call_dae)
        service.call
        configuration.reload
      end

      it { expect(service).to have_received(:call_der) }
      it { expect(service).to have_received(:call_dae) }

      it { expect(configuration.status_success?).to be_truthy }
    end

  end

end
