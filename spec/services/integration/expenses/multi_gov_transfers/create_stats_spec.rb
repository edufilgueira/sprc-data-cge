require 'rails_helper'

describe Integration::Expenses::MultiGovTransfers::CreateStats do

  let(:undefined_multi_gov_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_multi_gov_data) do
    {
      exercicio: year,
      valor: 500,
      management_unit: management_unit
    }
  end

  let(:first_multi_gov_transfer) { create(:integration_expenses_multi_gov_transfer, base_multi_gov_data) }

  before do
    create(:integration_expenses_multi_gov_transfer, base_multi_gov_data)

    nld_data = base_multi_gov_data.merge({
       ned: first_multi_gov_transfer,
       exercicio_restos_a_pagar: first_multi_gov_transfer.exercicio,
       unidade_gestora: first_multi_gov_transfer.unidade_gestora,
       numero_nota_empenho_despesa: first_multi_gov_transfer.numero
    })

    nld = create(:integration_expenses_nld, nld_data)

    create(:integration_expenses_npd, base_multi_gov_data.merge({ exercicio: nld.exercicio, numero_nld_ordinaria: nld.numero, valor: 200 }))

    create(:integration_expenses_multi_gov_transfer, base_multi_gov_data.merge({exercicio: year - 2.years}))
  end

  describe 'data' do
    it 'total' do
      multi_gov_data = base_multi_gov_data

      create(:integration_expenses_multi_gov_transfer, multi_gov_data.merge({exercicio: year - 2.years}))

      expected_data = {
        total: {
          calculated_valor_final: 1000,
          calculated_valor_pago_final: 200,
          count: 2
        }
      }

      Integration::Expenses::MultiGovTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::MultiGovTransfer.find_by(year: year, month: 0)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'management_unit' do
      management_unit = create(:integration_supports_management_unit, codigo: '1234')

      multi_gov_data = base_multi_gov_data.merge({
        management_unit: management_unit,
        unidade_gestora: 1234
      })

      first_multi_gov_transfer.update(multi_gov_data)
      create(:integration_expenses_multi_gov_transfer, multi_gov_data)

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

      Integration::Expenses::MultiGovTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::MultiGovTransfer.find_by(year: year, month: 0)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'razao_social_credor' do
      razao_social_credor_title = 'CREDOR'

      multi_gov_data = base_multi_gov_data.merge({
        razao_social_credor: razao_social_credor_title
      })

      first_multi_gov_transfer.update(multi_gov_data)
      create(:integration_expenses_multi_gov_transfer, multi_gov_data)

      expected_data = {
        razao_social_credor: {
          razao_social_credor_title => {
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::MultiGovTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::MultiGovTransfer.find_by(year: year, month: 0)

      expect(generated.data[:razao_social_credor][razao_social_credor_title]).to eq(expected_data[:razao_social_credor][razao_social_credor_title])
    end
  end
end
