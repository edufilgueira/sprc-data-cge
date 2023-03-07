require 'rails_helper'

describe Integration::Revenues::Accounts::CreateSpreadsheet do

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953') }
  let(:revenue) { create(:integration_revenues_revenue, year: year, month: month, unidade: organ.codigo_orgao) }
  let(:account) { create(:integration_revenues_account, revenue: revenue, conta_corrente: "#{revenue_nature.codigo}.20500", mes: month_end)}

  let(:date) { (Date.today - 2.years).beginning_of_month }
  let(:month) { date.month }
  let(:month_start) { 1 }
  let(:month_end) { date.month }
  let(:month_range) { { month_start: month_start, month_end: month_end } }
  let(:year) { date.year }

  subject(:service) { Integration::Revenues::Accounts::CreateSpreadsheet.new(year, 0, month_range) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base contract dir' do
    dir = Rails.root + "/public/files/downloads/integration/revenues/#{year}_#{month_start}_#{month_end}/"

    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "/public/files/downloads/integration/revenues/#{year}_#{month_start}_#{month_end}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  it 'resources' do
    account

    service.call

    result = service.send(:resources)
    expected = Integration::Revenues::Account.joins({ revenue: :organ }, :revenue_nature).from_month_range(month_start, month_end, year)

    expect(result).to eq(expected)
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      account

      expected_title = I18n.t("integration/revenues/account.spreadsheet.worksheets.default.title", year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      account
      expect(service).to receive(:xls_add_header).with(anything, Integration::Revenues::Account::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/revenues/#{year}_#{month_start}_#{month_end}/receitas_poder_executivo_#{year}_#{month_start}_#{month_end}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/revenues/#{year}_#{month_start}_#{month_end}/receitas_poder_executivo_#{year}_#{month_start}_#{month_end}.csv"

      account

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
