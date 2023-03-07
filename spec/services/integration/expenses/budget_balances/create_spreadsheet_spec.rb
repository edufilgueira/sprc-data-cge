require 'rails_helper'

describe Integration::Expenses::BudgetBalances::CreateSpreadsheet do

  let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
  let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

  let(:budget_balance) { create(:integration_expenses_budget_balance, cod_unid_gestora: organ.codigo_orgao, ano_mes_competencia: "#{month}-#{year}") }

  let(:date) { (Date.today - 2.years).beginning_of_month }

  let(:year) { date.year }

  let(:month) { date.month > 1 ? date.month - 1 : 1}
  let(:month_start) { 1 }
  let(:month_end) { month }
  let(:month_range) { { month_start: month_start, month_end: month_end } }

  subject(:service) { Integration::Expenses::BudgetBalances::CreateSpreadsheet.new(year, 0, month_range) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  it 'creates base contract dir' do
    dir = Rails.root + "/public/files/downloads/integration/expenses/budget_balances/#{year}_#{month_start}_#{month_end}/"
    FileUtils.rm_rf(dir) if File.exist?(dir)

    subject.call

    expect(File.exist?(dir)).to eq(true)
  end

  it 'overrides existing directory' do
    base_dir = Rails.root + "/public/files/downloads/integration/expenses/budget_balances/#{year}_#{month_start}_#{month_end}"
    test_file_path = "#{base_dir}/test_file"

    FileUtils.mkpath(base_dir.to_s)

    FileUtils.touch(test_file_path)
    expect(File.exist?(test_file_path)).to eq(true)

    subject.call

    expect(File.exist?(base_dir.to_s)).to eq(true)
    expect(File.exist?(test_file_path)).to eq(false)
  end

  it 'resources' do
    budget_balance

    service.call

    result = service.send(:resources)

    associations = [
      :secretary,
      :organ,
      :function,
      :sub_function,
      :government_program,
      :government_action,
      :administrative_region,
      :expense_nature,
      :qualified_resource_source,
      :finance_group
    ]

    expected = Integration::Expenses::BudgetBalance.
      from_month_range(year, month_start, month_end).
      includes(associations).
      references(associations).
      where('integration_supports_organs.poder = ?', 'EXECUTIVO')

     expect(result).to eq(expected)
  end

  context 'spreadsheet' do
    it 'adds worksheet with title' do
      budget_balance

      expected_title = I18n.t("integration/expenses/budget_balance.spreadsheet.worksheets.default.title", year: year)

      allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
      expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected_title)

      service.call
    end

    it 'adds header for worksheet_type' do
      budget_balance
      expect(service).to receive(:xls_add_header).with(anything, Integration::Expenses::BudgetBalance::SpreadsheetPresenter.spreadsheet_header)

      service.call
    end
  end

  context 'csv' do
    it 'converts xls to csv' do
      allow(Rails).to receive(:root).and_call_original

      xls_filename = Rails.root.to_s + "/public/files/downloads/integration/expenses/budget_balances/#{year}_#{month_start}_#{month_end}/despesas_poder_executivo_#{year}_#{month_start}_#{month_end}.xlsx"
      csv_filename = Rails.root.to_s + "/public/files/downloads/integration/expenses/budget_balances/#{year}_#{month_start}_#{month_end}/despesas_poder_executivo_#{year}_#{month_start}_#{month_end}.csv"

      budget_balance

      service.call

      expect(File.exists?(xls_filename)).to eq(true)
      expect(File.exists?(csv_filename)).to eq(true)
    end
  end
end
