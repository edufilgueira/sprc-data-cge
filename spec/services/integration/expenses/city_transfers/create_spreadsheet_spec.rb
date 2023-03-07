require 'rails_helper'

describe Integration::Expenses::CityTransfers::CreateSpreadsheet do

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:city_transfer) { create(:integration_expenses_city_transfer, unidade_gestora: management_unit.codigo, exercicio: "#{year}") }

  let(:date) { (Date.today - 2.years).beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }

  subject(:service) { Integration::Expenses::CityTransfers::CreateSpreadsheet.new(year, 0) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base contract dir' do
    dir = Rails.root + "/public/files/downloads/integration/expenses/city_transfers/#{year}/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "/public/files/downloads/integration/expenses/city_transfers/#{year}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  it 'resources' do
    city_transfer

    service.call

    result = service.send(:resources)

    associations = [
      :management_unit,
      :executing_unit,
      :budget_unit,
      :function,
      :sub_function,
      :government_program,
      :government_action,
      :administrative_region,
      :expense_nature,
      :resource_source,
      :expense_type,
      :creditor
    ]

    expected = Integration::Expenses::CityTransfer.
      from_executivo.
      from_year(year).
      includes(associations).
      references(associations)

     expect(result).to eq(expected)
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      city_transfer

      expected_title = I18n.t("integration/expenses/city_transfer.spreadsheet.worksheets.default.title", year: year).slice(0, 25)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      city_transfer
      expect(service).to receive(:xls_add_header).with(anything, Integration::Expenses::CityTransfer::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/expenses/city_transfers/#{year}/transferencias_municipios_#{year}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/expenses/city_transfers/#{year}/transferencias_municipios_#{year}.csv"

      city_transfer

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
