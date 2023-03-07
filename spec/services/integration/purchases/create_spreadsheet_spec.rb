require 'rails_helper'

describe Integration::Purchases::CreateSpreadsheet do

  let(:purchase) { create(:integration_purchases_purchase, data_publicacao: date) }
  let!(:old_purchase) { create(:integration_purchases_purchase, data_publicacao: date - 1.month) }

  let(:date) { Date.today.beginning_of_month }
  let(:month) { date.month }
  let(:year) { date.year }
  let(:year_month) { I18n.l(Date.new(year, month), format: '%Y%m') }
  let(:base_path) { '/public/files/downloads/integration/purchases' }

  subject(:service) { Integration::Purchases::CreateSpreadsheet.new(year, month) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base purchase dir' do
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
    it 'filters purchases' do
      purchase

      service.call

      result = service.send(:resources)

      expect(result).to eq([purchase])
    end
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      purchase

      expected_title = I18n.t("integration/purchases.spreadsheet.worksheets.default.title", month: month, year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      purchase
      expect(service).to receive(:xls_add_header).with(anything, Integration::Purchases::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "#{base_path}/#{year_month}/compras_#{year_month}.xlsx"
      csv_filename = Rails.root.to_s + "#{base_path}/#{year_month}/compras_#{year_month}.csv"

      purchase

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
