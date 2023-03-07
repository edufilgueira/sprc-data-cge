require 'rails_helper'

describe Integration::Expenses::CityTransfers::CreateStats do

  let(:undefined_city_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_city_data) do
    {
      exercicio: year,
      valor: 500,
      management_unit: management_unit
    }
  end

  let(:first_city_transfer) { create(:integration_expenses_city_transfer, base_city_data) }

  describe 'data' do

    before do
      create(:integration_expenses_city_transfer, base_city_data)

      nld_data = base_city_data.merge({
         ned: first_city_transfer,
         exercicio_restos_a_pagar: first_city_transfer.exercicio,
         unidade_gestora: first_city_transfer.unidade_gestora,
         numero_nota_empenho_despesa: first_city_transfer.numero
      })

      nld = create(:integration_expenses_nld, nld_data)

      create(:integration_expenses_npd, base_city_data.merge({ exercicio: nld.exercicio, numero_nld_ordinaria: nld.numero, valor: 200 }))

      create(:integration_expenses_city_transfer, base_city_data.merge({exercicio: year - 2.years}))
    end

    it 'total' do
      expected_data = {
        total: {
          calculated_valor_final: 1000,
          calculated_valor_pago_final: 200,
          count: 2
        }
      }

      Integration::Expenses::CityTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::CityTransfer.find_by(year: year, month: 0)

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

      Integration::Expenses::CityTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::CityTransfer.find_by(year: year, month: 0)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'razao_social_credor' do
      razao_social_credor_title = 'CREDOR'

      city_data = base_city_data.merge({
        razao_social_credor: razao_social_credor_title
      })

      first_city_transfer.update(city_data)
      create(:integration_expenses_city_transfer, city_data)

      expected_data = {
        razao_social_credor: {
          razao_social_credor_title => {
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::CityTransfers::CreateStats.call(year, 0)

      generated = Stats::Expenses::CityTransfer.find_by(year: year, month: 0)

      expect(generated.data[:razao_social_credor][razao_social_credor_title]).to eq(expected_data[:razao_social_credor][razao_social_credor_title])
    end
  end
end
