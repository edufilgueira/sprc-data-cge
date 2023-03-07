require 'rails_helper'

describe Integration::Constructions::Daes::CreateStats do

  describe 'dae' do

    describe 'totals' do

      let(:year) { Date.today.year }
      let(:month) { Date.today.month }
      let(:date) { Date.today.beginning_of_month }

      let(:base_dae_data) do
        {
          data_inicio: date - 1.year,
          data_fim_previsto: date + 2.years,
          valor: 500
        }
      end

      describe 'data' do
        it 'total' do
          dae_data = base_dae_data

          first = create(:integration_constructions_dae, dae_data)
          second = create(:integration_constructions_dae, dae_data)

          ignored_out_of_range = create(:integration_constructions_dae, dae_data.merge({data_inicio: date - 2.years, data_fim_previsto: date - 1.year}))

          expected_data = {
            total: {
              valor: 1000,
              count: 2
            }
          }

          Integration::Constructions::Daes::CreateStats.call(year, month)

          generated = Stats::Constructions::Dae.find_by(year: year, month: month)

          expect(generated.data[:total]).to eq(expected_data[:total])
        end

        it 'descricao' do
          dae_data = base_dae_data

          first = create(:integration_constructions_dae, dae_data.merge({descricao: 'obra1', valor: 1000}))
          second = create(:integration_constructions_dae, dae_data.merge({descricao: 'obra2', valor: 2000}))

          ignored_out_of_range = create(:integration_constructions_dae, dae_data.merge({data_inicio: date - 2.years, data_fim_previsto: date - 1.year}))

          expected_data = {
            descricao: {
              "obra1"=> {
                valor: 1000.0,
                count: 1
              },
              "obra2"=> {
                valor: 2000.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor: 0.0,
                count: 0
              }
            }

          }

          Integration::Constructions::Daes::CreateStats.call(year, month)

          generated = Stats::Constructions::Dae.find_by(year: year, month: month)

          expect(generated.data[:descricao]).to eq(expected_data[:descricao])

        end

        it 'municipio' do
          dae_data = base_dae_data

          first = create(:integration_constructions_dae, dae_data.merge({municipio: 'fortaleza', valor: 400}))
          second = create(:integration_constructions_dae, dae_data.merge({municipio: 'fortaleza', valor: 600}))
          third = create(:integration_constructions_dae, dae_data.merge({municipio: 'caninde', valor: 300}))

          ignored_out_of_range = create(:integration_constructions_dae, dae_data.merge({data_inicio: date - 2.years, data_fim_previsto: date - 1.year}))

          expected_data = {
            municipio: {
              "fortaleza"=> {
                valor: 1000.0,
                count: 2
              },
              "caninde"=> {
                valor: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Daes::CreateStats.call(year, month)

          generated = Stats::Constructions::Dae.find_by(year: year, month: month)

          expect(generated.data[:municipio]).to eq(expected_data[:municipio])
        end

        it 'secretaria' do
          dae_data = base_dae_data

          first = create(:integration_constructions_dae, dae_data.merge({secretaria: 'DETRAN', valor: 400}))
          second = create(:integration_constructions_dae, dae_data.merge({secretaria: 'DETRAN', valor: 600}))
          third = create(:integration_constructions_dae, dae_data.merge({secretaria: 'SESA', valor: 300}))

          ignored_out_of_range = create(:integration_constructions_dae, dae_data.merge({data_inicio: date - 2.years, data_fim_previsto: date - 1.year}))

          expected_data = {
            secretaria: {
              "DETRAN"=> {
                valor: 1000.0,
                count: 2
              },
              "SESA"=> {
                valor: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Daes::CreateStats.call(year, month)

          generated = Stats::Constructions::Dae.find_by(year: year, month: month)

          expect(generated.data[:secretaria]).to eq(expected_data[:secretaria])
        end

        it 'contratada' do
          dae_data = base_dae_data

          first = create(:integration_constructions_dae, dae_data.merge({contratada: 'Caiena', valor: 400}))
          second = create(:integration_constructions_dae, dae_data.merge({contratada: 'Caiena', valor: 600}))
          third = create(:integration_constructions_dae, dae_data.merge({contratada: 'outra', valor: 300}))

          ignored_out_of_range = create(:integration_constructions_dae, dae_data.merge({data_inicio: date - 2.years, data_fim_previsto: date - 1.year}))

          expected_data = {
            contratada: {
              "Caiena"=> {
                valor: 1000.0,
                count: 2
              },
              "outra"=> {
                valor: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Daes::CreateStats.call(year, month)

          generated = Stats::Constructions::Dae.find_by(year: year, month: month)

          expect(generated.data[:contratada]).to eq(expected_data[:contratada])
        end
      end
    end
  end

end
