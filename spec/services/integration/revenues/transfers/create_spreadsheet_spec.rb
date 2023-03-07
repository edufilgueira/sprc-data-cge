require 'rails_helper'

describe Integration::Revenues::Transfers::CreateSpreadsheet do

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '117213501') }
  let(:revenue) { create(:integration_revenues_revenue, year: year, month: month, unidade: organ.codigo_orgao) }
  let(:transfer) { create(:integration_revenues_transfer, revenue: revenue, conta_corrente: "#{revenue_nature.codigo}.20500") }

  let(:date) { (Date.today - 2.years).beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }

  subject(:service) { Integration::Revenues::Transfers::CreateSpreadsheet.new(year, 0) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base contract dir' do
    dir = Rails.root + "/public/files/downloads/integration/revenues/transfers/#{year}/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "/public/files/downloads/integration/revenues/transfers/#{year}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  it 'resources' do
    transfer

    service.call

    result = service.send(:resources)
    expected = Integration::Revenues::Transfer.joins({ revenue: :organ }, :revenue_nature).from_year(year)

    expect(result).to eq(expected)
  end

  context 'spreadsheet' do
    it 'adds header for worksheet_type' do
      transfer
      expect(service).to receive(:xls_add_header).with(anything, Integration::Revenues::Transfer::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/revenues/transfers/#{year}/receitas_poder_executivo_transferencias_#{year}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/revenues/transfers/#{year}/receitas_poder_executivo_transferencias_#{year}.csv"

      transfer

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
