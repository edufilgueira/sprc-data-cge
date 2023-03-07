require 'rails_helper'

describe Integration::Expenses::BudgetBalances::CreateStats do

  let(:undefined_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:month) { month_end > 1 ? month_end - 1 : 1}
  let(:month_start) { 1 }
  let(:month_end) { Date.today.month }
  let(:month_range) { { month_start: month_start, month_end: month_end } }

  let(:secretary) { create(:integration_supports_organ, :secretary) }

  let(:another_secretary) { create(:integration_supports_organ, :secretary) }

  let(:function) { create(:integration_supports_function) }
  let(:sub_function) { create(:integration_supports_sub_function) }
  let(:government_program) { create(:integration_supports_government_program) }
  let(:administrative_region) { create(:integration_supports_administrative_region, codigo_regiao: '1500000') }

  let(:valor_inicial_budget_balance) do
    create(:integration_expenses_budget_balance, valor_inicial_attributes)
  end

  let(:valor_inicial_attributes) do
    {
      ano_mes_competencia: "#{month}-#{year}",
      cod_unid_gestora: secretary.codigo_orgao,
      cod_funcao: function.codigo_funcao,
      cod_subfuncao: sub_function.codigo_sub_funcao,
      cod_programa: government_program.codigo_programa,
      cod_localizacao_gasto: administrative_region.codigo_regiao_resumido,
      valor_inicial: 100,
      valor_suplementado: 200,
      valor_anulado: 25,
      valor_empenhado: 125,
      valor_empenhado_anulado: 25,
      valor_liquidado: 50,
      valor_liquidado_anulado: 25,
      valor_pago: 75,
      valor_pago_anulado: 25
    }
  end

  describe 'data' do
    it 'total' do

      valor_inicial_budget_balance

      another = create(:integration_expenses_budget_balance, valor_inicial_attributes)

      out_of_range = create(:integration_expenses_budget_balance, valor_inicial_attributes.merge({ ano_mes_competencia: "#{month}-#{year + 2}" }))

      expected_data = {
        total: {
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial * 2,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado * 2,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado * 2,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado * 2,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago * 2,
          count: 2
        }
      }

      Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

      generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end
  end

  it 'secretary' do
    valor_inicial_budget_balance

    another = create(:integration_expenses_budget_balance, valor_inicial_attributes.merge(cod_unid_gestora: another_secretary.codigo_orgao))

    expected_data = {
      secretary: {
        secretary.title => {
          title: secretary.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        },

        another_secretary.title => {
          title: another_secretary.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        }
      }
    }

    Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

    generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

    expect(generated.data[:secretary][secretary.title]).to eq(expected_data[:secretary][secretary.title])
    expect(generated.data[:secretary][another_secretary.title]).to eq(expected_data[:secretary][another_secretary.title])
  end

  it 'function' do
    valor_inicial_budget_balance

    expected_data = {
      function: {
        function.title => {
          title: function.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        }
      }
    }

    Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

    generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

    expect(generated.data[:function][function.title]).to eq(expected_data[:function][function.title])
  end

  it 'sub_function' do
    valor_inicial_budget_balance

    expected_data = {
      sub_function: {
        sub_function.title => {
          title: sub_function.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        }
      }
    }

    Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

    generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

    expect(generated.data[:sub_function][sub_function.title]).to eq(expected_data[:sub_function][sub_function.title])
  end

  it 'government_program' do
    valor_inicial_budget_balance

    expected_data = {
      government_program: {
        government_program.title => {
          title: government_program.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        }
      }
    }

    Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

    generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

    expect(generated.data[:government_program][government_program.title]).to eq(expected_data[:government_program][government_program.title])
  end

  it 'administrative_region' do
    valor_inicial_budget_balance

    expected_data = {
      administrative_region: {
        administrative_region.title => {
          title: administrative_region.title,
          calculated_valor_orcamento_inicial: valor_inicial_budget_balance.calculated_valor_orcamento_inicial,
          calculated_valor_orcamento_atualizado: valor_inicial_budget_balance.calculated_valor_orcamento_atualizado,
          calculated_valor_empenhado: valor_inicial_budget_balance.calculated_valor_empenhado,
          calculated_valor_liquidado: valor_inicial_budget_balance.calculated_valor_liquidado,
          calculated_valor_pago: valor_inicial_budget_balance.calculated_valor_pago,
          count: 1
        }
      }
    }

    Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)

    generated = Stats::Expenses::BudgetBalance.find_by(year: year, month_start: month_start, month_end: month_end)

    expect(generated.data[:administrative_region][administrative_region.title]).to eq(expected_data[:administrative_region][administrative_region.title])
  end
end
