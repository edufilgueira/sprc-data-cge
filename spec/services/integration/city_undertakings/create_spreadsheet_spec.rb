require 'rails_helper'

describe Integration::CityUndertakings::CreateSpreadsheet do

  let(:contract) { create(:integration_contracts_contract) }
  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking, created_at: date, sic: contract.isn_sic) }
  let!(:old_city_undertaking) { create(:integration_city_undertakings_city_undertaking, created_at: date - 1.month, sic: contract.isn_sic) }

  let(:date) { Date.today.beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }
  let(:year_month) { I18n.l(Date.new(year, month), format: '%Y%m') }
  let(:base_path) { '/public/files/downloads/integration/city_undertakings' }

  subject(:service) { Integration::CityUndertakings::CreateSpreadsheet.new(year, month) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base city_undertaking dir' do
    dir = Rails.root + "#{base_path}/#{year_month}/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "#{base_path}/#{year_month}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  describe 'resources' do
    it 'filters city_undertakings' do
      city_undertaking

      service.call

      result = service.send(:resources)

      expect(result).to match_array([city_undertaking, old_city_undertaking])
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      city_undertaking

      expected_title = I18n.t("integration/city_undertakings.spreadsheet.worksheets.default.title", month: month, year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      city_undertaking
      expect(service).to receive(:xls_add_header).with(anything, Integration::CityUndertakings::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "#{base_path}/#{year_month}/empreendimentos_municipios_#{year_month}.xlsx"
      csv_filename = Rails.root.to_s + "#{base_path}/#{year_month}/empreendimentos_municipios_#{year_month}.csv"

      city_undertaking

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
