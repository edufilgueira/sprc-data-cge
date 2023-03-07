require 'rails_helper'

describe Integration::Expenses::BudgetBalanceImporterV2 do

  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Expenses::BudgetBalanceImporterV2.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::BudgetBalanceImporterV2).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Expenses::BudgetBalanceImporterV2.call(1)

      expect(Integration::Expenses::BudgetBalanceImporterV2).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to configuration' do
      expect(service.configuration).to eq(configuration)
    end
  end

  describe 'call' do
    describe 'xml response' do

      before do
        etl
        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:etl) { }
        it { expect(Integration::Expenses::BudgetBalance.count).to eq(0) }
      end

      describe 'create budget_balance' do
        let(:etl) { create(:etl_integration_budget_balance) }

        it { expect(Integration::Expenses::BudgetBalance.count).to eq(1) }
      end

      describe 'create budget_balance update' do
        
        let(:etl) { 
          create(:etl_integration_budget_balance)
          create(:etl_integration_budget_balance, valempenhado: 10000) 
        }

        it 'Budgetbalance has updated' do
          budget_balance = Integration::Expenses::BudgetBalance.last
          expect(Integration::Expenses::BudgetBalance.count).to eq(1)
          expect(budget_balance.valor_empenhado).to eq(10000.00)
        end
      end
    end
  end

  describe 'stats' do
    let(:body) { {} }

    let(:configuration) { create(:integration_expenses_configuration, started_at: Date.today, finished_at: Date.today ) }

    before do
      response = double()
      service.send(:start)
    end

    it 'create_stats' do
      current_month = Date.today.month
      current_year = Date.today.year

      (1..current_month).each do |month_start|
        month_range = { month_start: month_start, month_end: current_month }

        expect(Integration::Expenses::BudgetBalances::CreateStats).to receive(:call).with(current_year, 0, month_range)
      end

      service.call
    end

    it 'create_spreadsheets' do
      current_month = Date.today.month
      current_year = Date.today.year

      (1..current_month).each do |month_start|
        month_range = { month_start: month_start, month_end: current_month }

        expect(Integration::Expenses::BudgetBalances::CreateSpreadsheet).to receive(:call).with(current_year, 0, month_range)
      end

      service.call

    end
  end
end
