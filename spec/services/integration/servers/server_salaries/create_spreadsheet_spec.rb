require 'rails_helper'

describe Integration::Servers::ServerSalaries::CreateSpreadsheet do

  let(:server_salary) { create(:integration_servers_server_salary, date: date) }
  let(:date) { (Date.today - 2.years).beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }
  let(:year_month) { I18n.l(Date.new(year, month), format: '%Y%m') }

  subject(:create_spreadsheet) { Integration::Servers::ServerSalaries::CreateSpreadsheet.new(year, month) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base server_salary dir' do
    dir = Rails.root + "/public/files/downloads/integration/servers/server_salaries/#{year_month}/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "/public/files/downloads/integration/servers/server_salaries/#{year_month}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      server_salary

      expected_title = I18n.t("integration/servers/server_salary.spreadsheet.worksheets.default.title", month: month, year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      create_spreadsheet.call
    end

    it 'adds header for worksheet_type' do
      server_salary
      expect(create_spreadsheet).to receive(:xls_add_header).with(anything, Integration::Servers::ServerSalary::SpreadsheetPresenter.spreadsheet_header)

      create_spreadsheet.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/servers/server_salaries/#{year_month}/servidores_#{year_month}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/servers/server_salaries/#{year_month}/servidores_#{year_month}.csv"

      server_salary

      create_spreadsheet.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
