require 'rails_helper'

describe Integration::Macroregions::CreateStats do
  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    let(:base_investment_data) do
      {
        descricao_regiao: 'GRANDE FORTALEZA',
        descricao_poder: 'EXECUTIVO',
        ano_exercicio: Date.today.year,
        valor_lei: '10000'
      }
    end

    describe 'data' do
      let(:generated) { Stats::MacroregionInvestment.find_by(year: year, month: month) }

      let(:investment_data) { base_investment_data }

      let(:investment_old_date) do
        investment_data.merge(
          { ano_exercicio: date - 1.year }
        )
      end

      it 'total' do
        first = create(:integration_macroregions_macroregion_investiment, investment_data)
        second = create(:integration_macroregions_macroregion_investiment, investment_data)

        out_of_range = create(:integration_macroregions_macroregion_investiment, investment_old_date)

        expected_data = {
          total: {
            valor_lei: investment_data[:valor_lei].to_f*2,
            count: 2
          }
        }

        Integration::Macroregions::CreateStats.call(year, month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'regiao' do
        first = create(:integration_macroregions_macroregion_investiment, investment_data)
        second = create(:integration_macroregions_macroregion_investiment, investment_data)

        third_custom = { descricao_regiao: 'SERRA DA IBIAPABA' }
        third = create(:integration_macroregions_macroregion_investiment, investment_data.merge(third_custom))

        ignored_out_of_range = create(:integration_macroregions_macroregion_investiment, investment_old_date)

        expected_data = {
          descricao_regiao: {
            third.descricao_regiao => {
              valor_lei: investment_data[:valor_lei].to_f,
              count: 1
            },
            first.descricao_regiao => {
              valor_lei: investment_data[:valor_lei].to_f*2,
              count: 2
            }
          }
        }

        Integration::Macroregions::CreateStats.call(year, month)

        expect(generated.data[:descricao_regiao]).to eq(expected_data[:descricao_regiao])
      end

      it 'poder' do
        first = create(:integration_macroregions_macroregion_investiment, investment_data)
        second = create(:integration_macroregions_macroregion_investiment, investment_data)

        third_custom = { descricao_poder: 'MINISTÉRIO PÚBLICO' }
        third = create(:integration_macroregions_macroregion_investiment, investment_data.merge(third_custom))

        ignored_out_of_range = create(:integration_macroregions_macroregion_investiment, investment_old_date)

        expected_data = {
          descricao_poder: {
            third.descricao_poder => {
              valor_lei: investment_data[:valor_lei].to_f,
              count: 1
            },
            first.descricao_poder => {
              valor_lei: investment_data[:valor_lei].to_f*2,
              count: 2
            }
          }
        }

        Integration::Macroregions::CreateStats.call(year, month)

        expect(generated.data[:descricao_poder]).to eq(expected_data[:descricao_poder])
      end
    end
  end
end
