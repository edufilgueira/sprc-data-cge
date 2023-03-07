require 'rails_helper'

describe Integration::Eparcerias::TransferBankOrders::CreateSpreadsheet do

  let(:convenant) { create(:integration_contracts_contract, :convenio, isn_sic: 123) }
  let(:another_convenant) { create(:integration_contracts_contract, :convenio, isn_sic: 321) }
  let(:transfer_bank_orders) { create_list(:integration_eparcerias_transfer_bank_order, 2, contract: convenant, isn_sic: convenant.isn_sic) }
  let(:another_transfer_bank_orders) { create_list(:integration_eparcerias_transfer_bank_order, 2, contract: another_convenant, isn_sic: another_convenant.isn_sic) }

  subject(:service) { Integration::Eparcerias::TransferBankOrders::CreateSpreadsheet.new }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)

    stub_const('Integration::Eparcerias::TransferBankOrders::CreateSpreadsheet::MIN_TRANSFERS_ORDERS', 1)
  end

  it 'creates base transfer_bank_order dir' do
    transfer_bank_orders

    dir = Rails.root + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    transfer_bank_orders

    base_dir = Rails.root + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(true)
  end

  describe 'resources' do
    it 'filters transfer_bank_orders' do
      transfer_bank_orders

      service.call

      result = service.send(:resources)

      expect(result).to match_array(Integration::Contracts::Convenant.where(id: convenant))
    end

    it 'filters transfer_bank_orders by isn_sic' do
      transfer_bank_orders
      another_transfer_bank_orders

      service = Integration::Eparcerias::TransferBankOrders::CreateSpreadsheet.new([transfer_bank_orders.first.isn_sic])

      service.call

      result = service.send(:resources)

      expected = [transfer_bank_orders.first.contract]

      expect(result).to match_array(expected)
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      transfer_bank_orders

      expected_title = I18n.t("integration/eparcerias/transfer_bank_order.spreadsheet.worksheets.default.title")

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders/transfer_bank_order_#{convenant.isn_sic}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders/transfer_bank_order_#{convenant.isn_sic}.csv"

      transfer_bank_orders
      another_transfer_bank_orders

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end

end
