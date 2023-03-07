require 'rails_helper'

describe Integration::RealStates::CreateStats do

  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    let(:base_real_state_data) do
      {
        municipio: "Fortaleza",
        property_type: create(:integration_supports_real_states_property_type),
        occupation_type: create(:integration_supports_real_states_occupation_type),
        manager: create(:integration_supports_organ, orgao_sfp: false),
        area_projecao_construcao: "54.4",
        created_at: date
      }
    end

    describe 'data' do
      let(:generated) { Stats::RealState.find_by(year: year, month: month) }

      let(:real_state_data) { base_real_state_data }

      let(:real_state_old_date) do
        real_state_data.merge(
          { created_at: date - 1.month }
        )
      end

      it 'total' do
        first = create(:integration_real_states_real_state, real_state_data)
        second = create(:integration_real_states_real_state, real_state_data)

        out_of_range = create(:integration_real_states_real_state, real_state_old_date)

        expected_data = {
          total: {
            area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f*3,
            count: 3
          }
        }

        Integration::RealStates::CreateStats.call(year, month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'occupation_type' do
        first = create(:integration_real_states_real_state, real_state_data)
        second = create(:integration_real_states_real_state, real_state_data)

        third_custom = { occupation_type: create(:integration_supports_real_states_occupation_type) }
        third = create(:integration_real_states_real_state, real_state_data.merge(third_custom))

        out_of_range = create(:integration_real_states_real_state, real_state_old_date)

        expected_data = {
          occupation_type: {
            first.occupation_type.title => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f*3,
              count: 3
            },
            third.occupation_type.title => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f,
              count: 1
            }
          }
        }

        Integration::RealStates::CreateStats.call(year, month)

        expect(generated.data[:occupation_type]).to eq(expected_data[:occupation_type])
      end

      it 'property_type' do
        first = create(:integration_real_states_real_state, real_state_data)
        second = create(:integration_real_states_real_state, real_state_data)

        third_custom = { property_type: create(:integration_supports_real_states_property_type) }
        third = create(:integration_real_states_real_state, real_state_data.merge(third_custom))

        out_of_range = create(:integration_real_states_real_state, real_state_old_date)

        expected_data = {
          property_type: {
            first.property_type.title => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f*3,
              count: 3
            },
            third.property_type.title => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f,
              count: 1
            }
          }
        }

        Integration::RealStates::CreateStats.call(year, month)

        expect(generated.data[:property_type]).to eq(expected_data[:property_type])
      end

      it 'manager' do
        first = create(:integration_real_states_real_state, real_state_data)
        second = create(:integration_real_states_real_state, real_state_data)

        third_custom = { manager: create(:integration_supports_organ, orgao_sfp: false) }
        third = create(:integration_real_states_real_state, real_state_data.merge(third_custom))

        out_of_range = create(:integration_real_states_real_state, real_state_old_date)

        expected_data = {
          manager: {
            first.manager.sigla => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f*3,
              count: 3
            },
            third.manager.sigla => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f,
              count: 1
            }
          }
        }

        Integration::RealStates::CreateStats.call(year, month)

        expect(generated.data[:manager]).to eq(expected_data[:manager])
      end

      it 'municipio' do
        first = create(:integration_real_states_real_state, real_state_data)
        second = create(:integration_real_states_real_state, real_state_data)

        third_custom = { municipio: "MUNICIPIO NOVO" }
        third = create(:integration_real_states_real_state, real_state_data.merge(third_custom))

        out_of_range = create(:integration_real_states_real_state, real_state_old_date)

        expected_data = {
          municipio: {
            first.municipio => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f*3,
              count: 3
            },
            third.municipio => {
              area_projecao_construcao: real_state_data[:area_projecao_construcao].to_f,
              count: 1
            }
          }
        }

        Integration::RealStates::CreateStats.call(year, month)

        expect(generated.data[:municipio]).to eq(expected_data[:municipio])
      end
    end
  end
end
