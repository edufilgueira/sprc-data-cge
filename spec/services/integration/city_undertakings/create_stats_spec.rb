require 'rails_helper'

describe Integration::CityUndertakings::CreateStats do

  let(:contract) { create(:integration_contracts_contract) }

  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }
    let!(:valor_executado_total) { 190_000 }

    let(:base_city_undertaking_data) do
      {
        municipio: "CANINDÉ",
        undertaking: create(:integration_supports_undertaking),
        creditor: create(:integration_supports_creditor),
        organ: create(:integration_supports_organ, orgao_sfp: false),
        created_at: date,
        sic: contract.isn_sic
      }
    end


    describe 'data' do
      let(:generated) { Stats::CityUndertaking.find_by(year: year, month: month) }


      let(:city_undertaking_data) do
        base_city_undertaking_data
      end

      let(:city_undertaking_old_date) do
        city_undertaking_data.merge(
          { created_at: date - 1.month }
        )
      end

      it 'total' do
        first = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)
        second = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)

        out_of_range = create(:integration_city_undertakings_city_undertaking, city_undertaking_old_date)

        expected_data = {
          total: {
            valor_executado_total: valor_executado_total.to_f*3,
            count: 3
          }
        }

        Integration::CityUndertakings::CreateStats.call(year, month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'creditor' do
        first = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)
        second = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)

        third_custom = { creditor: create(:integration_supports_creditor, nome: 'CREDITOR') }
        third = create(:integration_city_undertakings_city_undertaking, city_undertaking_data.merge(third_custom))

        out_of_range = create(:integration_city_undertakings_city_undertaking, city_undertaking_old_date)

        expected_data = {
          creditor: {
            first.creditor.title => {
              valor_executado_total: valor_executado_total.to_f*3,
              count: 3
            },
            third.creditor.title => {
              valor_executado_total: valor_executado_total.to_f,
              count: 1
            }
          }
        }

        Integration::CityUndertakings::CreateStats.call(year, month)

        expect(generated.data[:creditor]).to eq(expected_data[:creditor])
      end

      it 'undertaking' do
        first = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)
        second = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)

        third_custom = { undertaking: create(:integration_supports_undertaking) }
        third = create(:integration_city_undertakings_city_undertaking, city_undertaking_data.merge(third_custom))

        out_of_range = create(:integration_city_undertakings_city_undertaking, city_undertaking_old_date)

        expected_data = {
          undertaking: {
            first.undertaking.title => {
              valor_executado_total: valor_executado_total.to_f*3,
              count: 3
            },
            third.undertaking.title => {
              valor_executado_total: valor_executado_total.to_f,
              count: 1
            }
          }
        }

        Integration::CityUndertakings::CreateStats.call(year, month)

        expect(generated.data[:undertaking]).to eq(expected_data[:undertaking])
      end

      it 'organ' do
        first = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)
        second = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)

        third_custom = { organ: create(:integration_supports_organ, orgao_sfp: false) }
        third = create(:integration_city_undertakings_city_undertaking, city_undertaking_data.merge(third_custom))

        out_of_range = create(:integration_city_undertakings_city_undertaking, city_undertaking_old_date)

        expected_data = {
          organ: {
            first.organ.sigla => {
              valor_executado_total: valor_executado_total.to_f*3,
              count: 3
            },
            third.organ.sigla => {
              valor_executado_total: valor_executado_total.to_f,
              count: 1
            }
          }
        }

        Integration::CityUndertakings::CreateStats.call(year, month)

        expect(generated.data[:organ]).to eq(expected_data[:organ])
      end

      it 'municipio' do
        first = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)
        second = create(:integration_city_undertakings_city_undertaking, city_undertaking_data)

        third_custom = { municipio: "MUNICIPIO NOVO" }
        third = create(:integration_city_undertakings_city_undertaking, city_undertaking_data.merge(third_custom))

        out_of_range = create(:integration_city_undertakings_city_undertaking, city_undertaking_old_date)

        expected_data = {
          municipio: {
            first.municipio => {
              valor_executado_total: valor_executado_total.to_f*3,
              count: 3
            },
            third.municipio => {
              valor_executado_total: valor_executado_total.to_f,
              count: 1
            }
          }
        }

        Integration::CityUndertakings::CreateStats.call(year, month)

        expect(generated.data[:municipio]).to eq(expected_data[:municipio])
      end
    end
  end
end
