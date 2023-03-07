require 'rails_helper'

describe Integration::RealStates::CreateSpreadsheet do

  let(:real_state) { create(:integration_real_states_real_state, created_at: date) }
  let!(:old_real_state) { create(:integration_real_states_real_state, created_at: date - 1.month) }

  let(:date) { Date.today.beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }
  let(:year_month) { I18n.l(Date.new(year, month), format: '%Y%m') }
  let(:base_path) { '/public/files/downloads/integration/real_states' }

  subject(:service) { Integration::RealStates::CreateSpreadsheet.new(year, month) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base real_state dir' do
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
    it 'filters real_states' do
      real_state

      service.call

      result = service.send(:resources)

      expect(result).to match_array([real_state, old_real_state])
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      real_state

      expected_title = I18n.t("integration/real_states.spreadsheet.worksheets.default.title", month: month, year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      real_state
      expect(service).to receive(:xls_add_header).with(anything, Integration::RealStates::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "#{base_path}/#{year_month}/bens_imoveis_#{year_month}.xlsx"
      csv_filename = Rails.root.to_s + "#{base_path}/#{year_month}/bens_imoveis_#{year_month}.csv"

      real_state

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
