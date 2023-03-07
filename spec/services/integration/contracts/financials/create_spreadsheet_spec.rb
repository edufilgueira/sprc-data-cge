require 'rails_helper'

describe Integration::Contracts::Financials::CreateSpreadsheet do
  let(:convenant) { create(:integration_contracts_contract, :convenio, isn_sic: 123) }
  let(:another_convenant) { create(:integration_contracts_contract, :convenio, isn_sic: 321) }
  let(:financials) { create_list(:integration_contracts_financial, 2, contract: convenant, isn_sic: convenant.isn_sic) }
  let(:another_financials) { create_list(:integration_contracts_financial, 2, contract: another_convenant, isn_sic: another_convenant.isn_sic) }

  subject(:service) { Integration::Contracts::Financials::CreateSpreadsheet.new }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)

    stub_const('Integration::Contracts::Financials::CreateSpreadsheet::MIN_NEDS', 1)
  end

  it 'creates base financial dir' do
    financials

    dir = Rails.root + "/public/files/downloads/integration/contracts/financials/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    financials

    base_dir = Rails.root + "/public/files/downloads/integration/contracts/financials"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(true)
  end

  describe 'resources' do
    it 'filters financials' do
      financials

      service.call

      result = service.send(:resources)

      expect(result).to match_array(Integration::Contracts::Contract.unscoped.where(id: convenant))
    end

    it 'filters financials by isn_sic' do
      financials
      another_financials

      service = Integration::Contracts::Financials::CreateSpreadsheet.new([financials.first.isn_sic])
      service.call

      result = service.send(:resources)

      expected = [financials.first.contract.becomes(Integration::Contracts::Contract)]

      expect(result).to match_array(expected)
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      financials

      expected_title = I18n.t("integration/contracts/financial.spreadsheet.worksheets.default.title")

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/contracts/financials/financial_#{convenant.isn_sic}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/contracts/financials/financial_#{convenant.isn_sic}.csv"

      financials
      another_financials

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
