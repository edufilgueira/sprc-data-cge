require 'rails_helper'

describe Integration::Expenses::ProfitTransfers::CreateStats do

  let(:undefined_profit_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_profit_data) do
    {
      exercicio: year,
      valor: 500,
      management_unit: management_unit
    }
  end

  let(:first_profit_transfer) { create(:integration_expenses_profit_transfer, base_profit_data) }

  before do
    create(:integration_expenses_profit_transfer, base_profit_data)

    nld_data = base_profit_data.merge({
       ned: first_profit_transfer,
       exercicio_restos_a_pagar: first_profit_transfer.exercicio,
       unidade_gestora: first_profit_transfer.unidade_gestora,
       numero_nota_empenho_despesa: first_profit_transfer.numero
    })

    nld = create(:integration_expenses_nld, nld_data)

    create(:integration_expenses_npd, base_profit_data.merge({ exercicio: nld.exercicio, numero_nld_ordinaria: nld.numero, valor: 200 }))

    create(:integration_expenses_profit_transfer, base_profit_data.merge({exercicio: year - 2.years}))
  end

  describe 'data' do
    it 'total' do
      non_profit_data = base_profit_data

      ignored_out_of_range = create(:integration_expenses_profit_transfer, non_profit_data.merge({exercicio: year - 2.years}))

      expected_data = {
        total: {
          calculated_valor_final: 1000,
          calculated_valor_pago_final: 200,
          count: 2
        }
      }

      Integration::Expenses::ProfitTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ProfitTransfer.find_by(year: year, month: 0)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'management_unit' do
      expected_data = {
        management_unit: {
          management_unit.codigo => {
            title: management_unit.title,
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::ProfitTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ProfitTransfer.find_by(year: year, month: 0)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'razao_social_credor' do
      razao_social_credor_title = 'CREDOR'

      non_profit_data = base_profit_data.merge({
        razao_social_credor: razao_social_credor_title
      })

      first_profit_transfer.update(non_profit_data)
      create(:integration_expenses_profit_transfer, non_profit_data)

      expected_data = {
        razao_social_credor: {
          razao_social_credor_title => {
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::ProfitTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ProfitTransfer.find_by(year: year, month: 0)

      expect(generated.data[:razao_social_credor][razao_social_credor_title]).to eq(expected_data[:razao_social_credor][razao_social_credor_title])
    end
  end
end
