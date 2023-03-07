require 'rails_helper'

describe Integration::Expenses::ConsortiumTransfers::CreateStats do

  let(:undefined_consortium_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_consortium_data) do
    {
      exercicio: year,
      valor: 500,
      management_unit: management_unit
    }
  end

  let(:first_consortium_transfer) { create(:integration_expenses_consortium_transfer, base_consortium_data) }

  before do
    create(:integration_expenses_consortium_transfer, base_consortium_data)

    nld_data = base_consortium_data.merge({
       ned: first_consortium_transfer,
       exercicio_restos_a_pagar: first_consortium_transfer.exercicio,
       unidade_gestora: first_consortium_transfer.unidade_gestora,
       numero_nota_empenho_despesa: first_consortium_transfer.numero
    })

    nld = create(:integration_expenses_nld, nld_data)

    create(:integration_expenses_npd, base_consortium_data.merge({ exercicio: nld.exercicio, numero_nld_ordinaria: nld.numero, valor: 200 }))

    create(:integration_expenses_consortium_transfer, base_consortium_data.merge({exercicio: year - 2.years}))
  end

  describe 'data' do
    it 'total' do
      consortium_data = base_consortium_data

      ignored_out_of_range = create(:integration_expenses_consortium_transfer, consortium_data.merge({exercicio: year - 2.years}))

      expected_data = {
        total: {
          calculated_valor_final: 1000,
          calculated_valor_pago_final: 200,
          count: 2
        }
      }

      Integration::Expenses::ConsortiumTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ConsortiumTransfer.find_by(year: year, month: 0)

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

      Integration::Expenses::ConsortiumTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ConsortiumTransfer.find_by(year: year, month: 0)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'razao_social_credor' do
      razao_social_credor_title = 'CREDOR'

      consortium_data = base_consortium_data.merge({
        razao_social_credor: razao_social_credor_title
      })

      first_consortium_transfer.update(consortium_data)
      create(:integration_expenses_consortium_transfer, consortium_data)

      expected_data = {
        razao_social_credor: {
          razao_social_credor_title => {
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::ConsortiumTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::ConsortiumTransfer.find_by(year: year, month: 0)
    end
  end
end
