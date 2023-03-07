require 'rails_helper'

describe Integration::Revenues::Transfers::CreateStats do

  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    # Regras documentadas:
    #
    # natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '1' faça (valor_debito - valor_credito)

    # natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '1' faça (valor_credito - valor_debito)
    #
    # 5211 – Previsão de Receita
    # 52121 – Previsão de Receita Adicional
    # 52129 – Anulação de Previsão de Receita
    # 6212 – Receita Corrente
    # 6213 – Deduções da Receita
    #
    # Valor Previsto = 5211
    # Valor Atualizado = (5211 + 52121) – 52129
    # Valor Arrecadado = 6212 - 6213
    #
    #
    # Integration::Revenues::Revenue possui relação com órgão/secretaria, além
    # de possuir os códigos.
    #
    # A soma deve ser feita no model Integration::Revenues::Account, que possui
    # a classificação da natureza da receita.
    #

    let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
    let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

    let(:another_secretary) { create(:integration_supports_organ, :secretary) }
    let(:another_organ) { create(:integration_supports_organ, codigo_entidade: another_secretary.codigo_entidade, orgao_sfp: false) }

    let(:previsao_inicial_revenue) do
      create(:integration_revenues_revenue, previsao_inicial_attributes)
    end

    let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '117213501')} # obrigatória

    let(:previsao_inicial_attributes) do
      {
        # Valor previsto inicial vem das contas '5.2.1.1.1' (Previsão inicial)
        # e é calculada da seguinte forma:
        #
        # (valor_inicial + (valor_credito - valor_debito))

        organ: organ,
        poder: 'EXECUTIVO',
        unidade: organ.codigo_orgao,
        conta_contabil: '5.2.1.1.1', # Previsão inicial
        natureza_da_conta: 'CRÉDITO',

        # Somamos das contas e não das 'revenues', por isso o valor está diferente
        # da soma das contas. Para que o teste quebre caso alguém tente 'otimizar'
        # e somar das revenues.
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: month,
        year: year,

        accounts_attributes: [
          {
            conta_corrente: "#{revenue_nature.codigo}.20500",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: month,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          },

          {
            conta_corrente: "#{revenue_nature.codigo}.27000",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: month,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          }
        ]
      }
    end

    let(:out_of_range_previsao_inicial_attributes) do

      previsao_inicial_attributes.merge({
        month: month - 1,
        year: year - 1,

        accounts_attributes: [
          {
            conta_corrente: "#{revenue_nature.codigo}.20500",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: month - 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          },

          {
            conta_corrente: "#{revenue_nature.codigo}.27000",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: month - 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          }
        ]
      })
    end

    let(:out_of_range_previsao_inicial_revenue) do
      create(:integration_revenues_revenue, out_of_range_previsao_inicial_attributes)
    end

    describe 'data' do

      describe 'total' do
        it 'valor_previsto_inicial' do
          previsao_inicial_revenue
          out_of_range_previsao_inicial_revenue

          expected_value = (100) + (200 - 50) # 250
          expect_count = 1

          Integration::Revenues::Transfers::CreateStats.call(year, month)

          generated = Stats::Revenues::Transfer.find_by(year: year, month: month).data[:total]

          expect(generated[:valor_previsto_inicial]).to eq(expected_value)
          expect(generated[:count]).to eq(expect_count)
        end

        describe 'valor_previsto_atualizado' do
          # Valor Atualizado = (5211 + 52121) – 52129
          # 5211 – Previsão de Receita
          # 52121 – Previsão de Receita Adicional
          # 52129 – Anulação de Previsão de Receita

          let(:previsao_receita_adicional_attributes) do
            {
              # Previsão receita adicional vem das contas '5.2.1.2.1.0.1' (Previsão de Receita Adicional)

              organ: organ,
              poder: 'EXECUTIVO',
              unidade: organ.codigo_orgao,
              conta_contabil: '5.2.1.2.1.0.1',
              natureza_da_conta: 'CRÉDITO',
              valor_inicial: 100,
              valor_credito: 200,
              valor_debito: 50,
              month: month,
              year: year,

              accounts_attributes: [
                {
                  conta_corrente: "#{revenue_nature.codigo}.20500",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 50,
                  valor_credito: 100,
                  valor_debito: 25
                },

                {
                  conta_corrente: "#{revenue_nature.codigo}.27000",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 50,
                  valor_credito: 100,
                  valor_debito: 25
                }
              ]
            }
          end

          let(:anulacao_previsao_receita_attributes) do
            {
              # Anulação da receita adicional vem das contas '5.2.1.2.9' (Anulação de Previsão de Receita)

              organ: organ,
              poder: 'EXECUTIVO',
              unidade: organ.codigo_orgao,
              conta_contabil: '5.2.1.2.9',
              natureza_da_conta: 'CRÉDITO',
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25,
              month: month,
              year: year,

              accounts_attributes: [
                {
                  conta_corrente: "#{revenue_nature.codigo}.20500",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 25,
                  valor_credito: 50,
                  valor_debito: 12.5
                },

                {
                  conta_corrente: "#{revenue_nature.codigo}.27000",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 25,
                  valor_credito: 50,
                  valor_debito: 12.5
                }
              ]
            }
          end

          let(:previsao_receita_adicional_revenue) do
            create(:integration_revenues_revenue, previsao_receita_adicional_attributes)
          end

          let(:anulacao_previsao_receita_revenue) do
            create(:integration_revenues_revenue, anulacao_previsao_receita_attributes)
          end

          it 'calculates from multiple accounts' do
            previsao_inicial_revenue
            previsao_receita_adicional_revenue
            anulacao_previsao_receita_revenue

            # Esperado:

            valor_previsto_inicial = (100) + (200 - 50) # 250
            valor_previsto_adicional = (100 + 200 - 50) # 250
            valor_previsto_anulado = (50 + 100 - 25) # 125

            expected_value = (valor_previsto_inicial + valor_previsto_adicional - valor_previsto_anulado)


            Integration::Revenues::Transfers::CreateStats.call(year, month)
            expect_count = 3

            generated = Stats::Revenues::Transfer.find_by(year: year, month: month).data[:total]

            expect(generated[:valor_previsto_atualizado]).to eq(expected_value)
            expect(generated[:count]).to eq(expect_count)
          end

          it 'calculates for year' do
            previsao_inicial_revenue
            previsao_receita_adicional_revenue
            anulacao_previsao_receita_revenue

            # Esperado:

            valor_previsto_inicial = (100) + (200 - 50) # 250
            valor_previsto_adicional = (100 + 200 - 50) # 250
            valor_previsto_anulado = (50 + 100 - 25) # 125

            expected_value = (valor_previsto_inicial + valor_previsto_adicional - valor_previsto_anulado)

            Integration::Revenues::Transfers::CreateStats.call(year, 0)
            expect_count = 3

            generated = Stats::Revenues::Transfer.find_by(year: year, month: 0).data[:total]

            expect(generated[:valor_previsto_atualizado]).to eq(expected_value)
            expect(generated[:count]).to eq(expect_count)
          end
        end


        describe 'valor_arrecadado' do
          # Valor Atualizado = (5211 + 52121) – 52129
          # 5211 – Previsão de Receita
          # 52121 – Previsão de Receita Adicional
          # 52129 – Anulação de Previsão de Receita

          let(:receita_corrente_attributes) do
            {
              # Receita corrente vem das contas '6.2.1.2' (Receita Corrente)

              organ: organ,
              poder: 'EXECUTIVO',
              unidade: organ.codigo_orgao,
              conta_contabil: '6.2.1.2',
              natureza_da_conta: 'CRÉDITO',
              valor_inicial: 100,
              valor_credito: 200,
              valor_debito: 50,
              month: month,
              year: year,

              accounts_attributes: [
                {
                  conta_corrente: "#{revenue_nature.codigo}.20500",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 50,
                  valor_credito: 100,
                  valor_debito: 25
                },

                {
                  conta_corrente: "#{revenue_nature.codigo}.27000",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 50,
                  valor_credito: 100,
                  valor_debito: 25
                }
              ]
            }
          end

          let(:deducao_receita_attributes) do
            {
              # Deduções da Receita vem das contas '6.2.1.3' (Deduções da Receita)

              organ: organ,
              poder: 'EXECUTIVO',
              unidade: organ.codigo_orgao,
              conta_contabil: '6.2.1.3',
              natureza_da_conta: 'CRÉDITO',
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25,
              month: month,
              year: year,

              accounts_attributes: [
                {
                  conta_corrente: "#{revenue_nature.codigo}.20500",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 25,
                  valor_credito: 50,
                  valor_debito: 12.5
                },

                {
                  conta_corrente: "#{revenue_nature.codigo}.27000",
                  natureza_debito: 'CRÉDITO',
                  natureza_credito: 'DÉBITO',
                  mes: month,
                  valor_inicial: 25,
                  valor_credito: 50,
                  valor_debito: 12.5
                }
              ]
            }
          end

          let(:receita_corrente_revenue) do
            create(:integration_revenues_revenue, receita_corrente_attributes)
          end

          let(:deducao_receita_revenue) do
            create(:integration_revenues_revenue, deducao_receita_attributes)
          end

          let(:previsao_receita_adicional_revenue) do
            create(:integration_revenues_revenue, previsao_receita_adicional_attributes)
          end

          let(:anulacao_previsao_receita_revenue) do
            create(:integration_revenues_revenue, anulacao_previsao_receita_attributes)
          end

          it 'calculates from multiple accounts' do
            receita_corrente_revenue
            deducao_receita_revenue

            # Esperado:

            receita_corrente = (100) + (200 - 50) # 250
            deducoes = (50 + 100 - 25) # 125

            expected_value = (receita_corrente - deducoes)

            Integration::Revenues::Transfers::CreateStats.call(year, month)
            expect_count = 2

            generated = Stats::Revenues::Transfer.find_by(year: year, month: month).data[:total]

            expect(generated[:valor_arrecadado]).to eq(expected_value)
            expect(generated[:count]).to eq(expect_count)
          end
        end
      end

      describe 'secretary' do
        it 'valor_previsto_inicial' do
          previsao_inicial_revenue

          another_revenue_attributes = previsao_inicial_attributes.merge({
            organ: another_organ,
            unidade: another_organ.codigo_orgao
          })

          another_revenue = create(:integration_revenues_revenue, another_revenue_attributes)


          Integration::Revenues::Transfers::CreateStats.call(year, month)

          generated = Stats::Revenues::Transfer.find_by(year: year, month: month).data[:secretary]

          expect(generated.keys).to match_array([secretary.title, another_secretary.title])

          first_data, second_data = generated.values

          expect(first_data[:valor_previsto_inicial]).to eq(250)

          expect(second_data[:valor_previsto_inicial]).to eq(250)
        end
      end

      describe 'transfer' do # Tipo de transferências
        let(:first_revenue_nature_subalinea) { create(:integration_supports_revenue_nature, codigo: '117213501')} # obrigatória

        let(:second_revenue_nature_subalinea) { create(:integration_supports_revenue_nature, codigo: '117212220')} # voluntária

        let(:previsao_inicial_attributes) do
          {
            # Valor previsto inicial vem das contas '5.2.1.1.1' (Previsão inicial)
            # e é calculada da seguinte forma:
            #
            # (valor_inicial + (valor_credito - valor_debito))

            organ: organ,
            poder: 'EXECUTIVO',
            unidade: organ.codigo_orgao,
            conta_contabil: '5.2.1.1.1', # Previsão inicial
            natureza_da_conta: 'CRÉDITO',
            valor_inicial: 100,
            valor_credito: 200,
            valor_debito: 50,
            month: month,
            year: year,

            accounts_attributes: [
              {
                conta_corrente: "#{first_revenue_nature_subalinea.codigo}.20500",
                natureza_debito: 'CRÉDITO',
                natureza_credito: 'DÉBITO',
                mes: month,
                valor_inicial: 50,
                valor_credito: 100,
                valor_debito: 25
              },

              {
                conta_corrente: "#{second_revenue_nature_subalinea.codigo}.27000",
                natureza_debito: 'CRÉDITO',
                natureza_credito: 'DÉBITO',
                mes: month,
                valor_inicial: 50,
                valor_credito: 100,
                valor_debito: 25
              }
            ]
          }
        end

        it 'valor_previsto_inicial' do
          previsao_inicial_revenue

          Integration::Revenues::Transfers::CreateStats.call(year, month)

          generated = Stats::Revenues::Transfer.find_by(year: year, month: month).data[:transfer]

          titles = [Integration::Supports::RevenueNature.human_attribute_name(:transfer_required), Integration::Supports::RevenueNature.human_attribute_name(:transfer_voluntary)]

          expect(generated.keys).to eq(titles)

          first_data, second_data = generated.values

          expect(first_data[:valor_previsto_inicial]).to eq(125)

          expect(second_data[:valor_previsto_inicial]).to eq(125)
        end
      end
    end
  end
end
