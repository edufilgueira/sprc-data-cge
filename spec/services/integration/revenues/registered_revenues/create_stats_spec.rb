require 'rails_helper'

describe Integration::Revenues::RegisteredRevenues::CreateStats do

  describe 'totals' do

    # Regras documentadas:
    #
    # natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '1' faça (valor_debito - valor_credito)

    # natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '1' faça (valor_credito - valor_debito)
    #
    # - 4.1.1.2.1.03.01 IPVA
    # - 4.1.1.2.1.97.01 (-) Restituições da Receita com IPVA
    # - 4.1.1.2.1.97.11 (-) Deduções do IPVA para o FUNDEB
    #
    # Valor lançado = IPVA - Restituições da Receita com IPVA -  Deduções do IPVA para o FUNDEB
    # Valor Atualizado = (5211 + 52121) – 52129
    # Valor Arrecadado = 6212 - 6213
    #

    let(:year) { 2018 }

    let(:another_year) { 2019 }

    let(:ipva_revenue) do
      create(:integration_revenues_revenue, ipva_attributes)
    end

    let(:another_month_ipva_revenue) do
      create(:integration_revenues_revenue, another_month_ipva_attributes)
    end

    let(:another_year_ipva_revenue) do
      create(:integration_revenues_revenue, another_year_ipva_attributes)
    end

    let(:restituicoes_ipva_revenue) do
      create(:integration_revenues_revenue, restituicoes_ipva_attributes)
    end

    let(:deducoes_ipva_revenue) do
      create(:integration_revenues_revenue, deducoes_ipva_attributes)
    end

    let(:ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.03.01', # IPVA
        titulo: 'IPVA',
        natureza_da_conta: 'CRÉDITO',
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: 1,
        year: year
      }
    end

    let(:another_month_ipva_attributes) do
      ipva_attributes.merge({
        month: 2,
        year: year
      })
    end

    let(:another_year_ipva_attributes) do
      ipva_attributes.merge({
        month: 1,
        year: another_year
      })
    end

    let(:restituicoes_ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.97.01', # Restituições da Receita com IPVA
        natureza_da_conta: 'DÉBITO',
        titulo: 'Restituições da Receita com IPVA',
        valor_inicial: 10,
        valor_credito: 20,
        valor_debito: 30,
        month: 1,
        year: year
      }
    end

    let(:deducoes_ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.97.11', # (-) Deduções do IPVA para o FUNDEB
        natureza_da_conta: 'DÉBITO',
        titulo: 'Deduções do IPVA para o FUNDEB',
        valor_inicial: 5,
        valor_credito: 10,
        valor_debito: 15,
        month: 1,
        year: year
      }
    end

    describe 'data' do
      describe 'total' do
        it 'valor_lancado' do
          month = 1
          ipva_revenue
          restituicoes_ipva_revenue
          deducoes_ipva_revenue

          another_month = 2
          another_month_ipva_revenue

          another_year_ipva_revenue

          valor_ipva = ((100) + (200 - 50)) * 2 # 500
          valor_restituicoes = (10) + (30 - 20) # 20
          valor_deducoes = (5) + (15 - 10) # 10
          valor_lancado = (valor_ipva - valor_restituicoes - valor_deducoes)

          expected_value = valor_lancado
          expect_count = 4

          Integration::Revenues::RegisteredRevenues::CreateStats.call(year, 0)

          generated = Stats::Revenues::RegisteredRevenue.find_by(year: year, month: 0).data[:total]

          expect(generated[:valor_lancado]).to eq(expected_value)
          expect(generated[:count]).to eq(expect_count)
        end
      end

      describe 'month' do
        it 'valor_lancado' do
          month = 1
          ipva_revenue
          restituicoes_ipva_revenue
          deducoes_ipva_revenue

          another_month = 2
          another_month_ipva_revenue

          another_year_ipva_revenue

          Integration::Revenues::RegisteredRevenues::CreateStats.call(year, 0)

          generated = Stats::Revenues::RegisteredRevenue.find_by(year: year, month: 0).data[:month]

          expect(generated.keys).to eq([month, another_month])

          first_month = generated[month]
          second_month = generated[another_month]

          expect(first_month[:valor_lancado]).to eq(250 - 30)
          expect(second_month[:valor_lancado]).to eq(250)
        end
      end

      describe 'revenue' do
        it 'valor_lancado' do
          month = 1
          ipva_revenue
          restituicoes_ipva_revenue
          deducoes_ipva_revenue

          another_month = 2
          another_month_ipva_revenue

          another_year_ipva_revenue

          Integration::Revenues::RegisteredRevenues::CreateStats.call(year, 0)

          generated = Stats::Revenues::RegisteredRevenue.find_by(year: year, month: 0).data[:revenue]

          expect(generated.keys).to match_array(['IPVA', 'Restituições da Receita com IPVA', 'Deduções do IPVA para o FUNDEB'])

          first = generated['IPVA']
          second = generated['Restituições da Receita com IPVA']
          third = generated['Deduções do IPVA para o FUNDEB']

          expect(first[:valor_lancado]).to eq(500)
          expect(second[:valor_lancado]).to eq(-20)
          expect(third[:valor_lancado]).to eq(-10)
        end
      end
    end
  end
end
