require 'rails_helper'

describe Integration::Results::StrategicIndicators::CreateSpreadsheet do

  let(:indicator) { create(:integration_results_strategic_indicator, created_at: date) }
  let!(:old_indicator) { create(:integration_results_strategic_indicator, created_at: date - 1.month) }

  let(:date) { Date.today.beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }
  let(:year_month) { I18n.l(Date.new(year, month), format: '%Y%m') }
  let(:base_path) { '/public/files/downloads/integration/results/strategic_indicators' }

  subject(:service) { Integration::Results::StrategicIndicators::CreateSpreadsheet.new(year, month) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base indicator dir' do
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
    it 'filters strategic_indicator' do
      indicator

      service.call

      result = service.send(:resources)

      expect(result).to match_array([indicator, old_indicator])
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      expected_title = I18n.t("integration/results/strategic_indicator.spreadsheet.worksheets.default.short_title", month: month, year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      indicator
      expect(service).to receive(:xls_add_header).with(anything, Integration::Results::StrategicIndicator::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "#{base_path}/#{year_month}/results_strategic_indicator_#{year_month}.xlsx"
      csv_filename = Rails.root.to_s + "#{base_path}/#{year_month}/results_strategic_indicator_#{year_month}.csv"

      indicator

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end

end
