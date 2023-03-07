require 'rails_helper'

describe Integration::Expenses::Importer do

  let(:configuration) { create(:integration_expenses_configuration) }

  let(:service) { Integration::Expenses::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Expenses::Importer.call(1)

      expect(Integration::Expenses::Importer).to have_received(:new).with(1)
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
        allow_any_instance_of(Integration::Expenses::NpfImporter).to receive(:call) { raise 'Error' }
        service.call
        configuration.reload
      end

      it { expect(configuration.status_fail?).to be_truthy }
    end

    describe 'success' do
      before do
        allow(Integration::Expenses::NpfImporter).to receive(:new)
        allow(Integration::Expenses::NedImporter).to receive(:new)
        allow(Integration::Expenses::NldImporter).to receive(:new)
        allow(Integration::Expenses::NpdImporter).to receive(:new)
        allow(Integration::Expenses::BudgetBalanceImporter).to receive(:new)
        service.call
      end

      it { expect(Integration::Expenses::NpfImporter).to have_received(:new) }
      it { expect(Integration::Expenses::NedImporter).to have_received(:new) }
      it { expect(Integration::Expenses::NldImporter).to have_received(:new) }
      it { expect(Integration::Expenses::NpdImporter).to have_received(:new) }
      it { expect(Integration::Expenses::BudgetBalanceImporter).to have_received(:new) }

      it { expect(configuration.reload).to be_status_success }
    end
  end
end
