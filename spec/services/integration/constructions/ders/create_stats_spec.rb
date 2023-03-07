require 'rails_helper'

describe Integration::Constructions::Ders::CreateStats do

  describe 'der' do

    describe 'totals' do

      let(:year) { Date.today.year }
      let(:month) { Date.today.month }
      let(:date) { Date.today.beginning_of_month }

      let(:base_der_data) do
        {
          data_fim_previsto: date + 2.years,
          valor_aprovado: 500
        }
      end

      describe 'data' do
        it 'total' do
          der_data = base_der_data

          first = create(:integration_constructions_der, der_data)
          second = create(:integration_constructions_der, der_data)

          ignored_out_of_range = create(:integration_constructions_der, der_data.merge({data_fim_previsto: date - 1.year}))

          expected_data = {
            total: {
              valor_aprovado: 1000,
              count: 2
            }
          }

          Integration::Constructions::Ders::CreateStats.call(year, month)

          generated = Stats::Constructions::Der.find_by(year: year, month: month)

          expect(generated.data[:total]).to eq(expected_data[:total])
        end

        it 'servicos' do
          der_data = base_der_data

          first = create(:integration_constructions_der, der_data.merge({servicos: 'obra1', valor_aprovado: 1000}))
          second = create(:integration_constructions_der, der_data.merge({servicos: 'obra2', valor_aprovado: 2000}))

          ignored_out_of_range = create(:integration_constructions_der, der_data.merge({data_fim_previsto: date - 1.year}))

          expected_data = {
            servicos: {
              "obra1"=> {
                valor_aprovado: 1000.0,
                count: 1
              },
              "obra2"=> {
                valor_aprovado: 2000.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor_aprovado: 0.0,
                count: 0
              }
            }

          }

          Integration::Constructions::Ders::CreateStats.call(year, month)

          generated = Stats::Constructions::Der.find_by(year: year, month: month)

          expect(generated.data[:servicos]).to eq(expected_data[:servicos])

        end

        it 'distrito' do
          der_data = base_der_data

          first = create(:integration_constructions_der, der_data.merge({distrito: '01 - MARANGUAPE', valor_aprovado: 400}))
          second = create(:integration_constructions_der, der_data.merge({distrito: '01 - MARANGUAPE', valor_aprovado: 600}))
          third = create(:integration_constructions_der, der_data.merge({distrito: '07 - SOBRAL', valor_aprovado: 300}))

          ignored_out_of_range = create(:integration_constructions_der, der_data.merge({data_fim_previsto: date - 1.year}))

          expected_data = {
            distrito: {
              "01 - MARANGUAPE"=> {
                valor_aprovado: 1000.0,
                count: 2
              },
              "07 - SOBRAL"=> {
                valor_aprovado: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor_aprovado: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Ders::CreateStats.call(year, month)

          generated = Stats::Constructions::Der.find_by(year: year, month: month)

          expect(generated.data[:distrito]).to eq(expected_data[:distrito])
        end

        it 'programa' do
          der_data = base_der_data

          first = create(:integration_constructions_der, der_data.merge({programa: 'Ceará III (004)', valor_aprovado: 400}))
          second = create(:integration_constructions_der, der_data.merge({programa: 'Ceará III (004)', valor_aprovado: 600}))
          third = create(:integration_constructions_der, der_data.merge({programa: 'Programa Rodoviário (180)', valor_aprovado: 300}))

          ignored_out_of_range = create(:integration_constructions_der, der_data.merge({data_fim_previsto: date - 1.year}))

          expected_data = {
            programa: {
              "Ceará III (004)"=> {
                valor_aprovado: 1000.0,
                count: 2
              },
              "Programa Rodoviário (180)"=> {
                valor_aprovado: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor_aprovado: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Ders::CreateStats.call(year, month)

          generated = Stats::Constructions::Der.find_by(year: year, month: month)

          expect(generated.data[:programa]).to eq(expected_data[:programa])
        end

        it 'construtora' do
          der_data = base_der_data

          first = create(:integration_constructions_der, der_data.merge({construtora: 'SAMARIA', valor_aprovado: 400}))
          second = create(:integration_constructions_der, der_data.merge({construtora: 'SAMARIA', valor_aprovado: 600}))
          third = create(:integration_constructions_der, der_data.merge({construtora: 'G & F', valor_aprovado: 300}))

          ignored_out_of_range = create(:integration_constructions_der, der_data.merge({data_fim_previsto: date - 1.year}))

          expected_data = {
            construtora: {
              "SAMARIA"=> {
                valor_aprovado: 1000.0,
                count: 2
              },
              "G & F"=> {
                valor_aprovado: 300.0,
                count: 1
              },
              I18n.t('messages.content.undefined') => {
                valor_aprovado: 0.0,
                count: 0
              }

            }
          }

          Integration::Constructions::Ders::CreateStats.call(year, month)

          generated = Stats::Constructions::Der.find_by(year: year, month: month)

          expect(generated.data[:construtora]).to eq(expected_data[:construtora])
        end
      end
    end
  end

end
