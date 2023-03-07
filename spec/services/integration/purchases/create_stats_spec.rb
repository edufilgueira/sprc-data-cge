require 'rails_helper'

describe Integration::Purchases::CreateStats do

  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    let(:base_purchase_data) do
      {
        nome_resp_compra: "HOSPITAL DE SAUDE MENTAL DE MESSEJANA",
        nome_fornecedor: "SUPRIMAX COMERCIAL LTDA - EPP",
        descricao_item: "EXTRATOR DE GRAMPOS, ACO CROMADO, 15 CM, CARTELA 1.0 UNIDADE",
        nome_grupo: "ARTIGOS E UTENSILIOS DE ESCRITORIO",
        valor_total_calculated: "27.3",
        data_publicacao: date
      }
    end

    describe 'data' do
      let(:generated) { Stats::Purchase.find_by(year: year, month: month) }

      let(:purchase_data) { base_purchase_data }

      let(:purchase_old_date) do
        purchase_data.merge(
          { data_publicacao: date - 1.month }
        )
      end

      it 'total' do
        first = create(:integration_purchases_purchase, purchase_data)
        second = create(:integration_purchases_purchase, purchase_data)

        ignored_out_of_range = create(:integration_purchases_purchase, purchase_old_date)

        expected_data = {
          total: {
            valor_total_calculated: purchase_data[:valor_total_calculated].to_f*2,
            count: 2
          }
        }

        Integration::Purchases::CreateStats.call(year, month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'itens' do
        first = create(:integration_purchases_purchase, purchase_data)
        second = create(:integration_purchases_purchase, purchase_data)

        third_custom = { descricao_item: "DESCRICAO NOVA" }
        third = create(:integration_purchases_purchase, purchase_data.merge(third_custom))

        ignored_out_of_range = create(:integration_purchases_purchase, purchase_old_date)

        expected_data = {
          itens: {
            first.descricao_item => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f*2,
              count: 2
            },
            third.descricao_item => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f,
              count: 1
            }
          }
        }

        Integration::Purchases::CreateStats.call(year, month)

        expect(generated.data[:itens]).to eq(expected_data[:itens])
      end

      it 'fornecedores' do
        first = create(:integration_purchases_purchase, purchase_data)
        second = create(:integration_purchases_purchase, purchase_data)

        third_custom = { nome_fornecedor: "FORNECEDOR NOVO" }
        third = create(:integration_purchases_purchase, purchase_data.merge(third_custom))

        ignored_out_of_range = create(:integration_purchases_purchase, purchase_old_date)

        expected_data = {
          fornecedores: {
            first.nome_fornecedor => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f*2,
              count: 2
            },
            third.nome_fornecedor => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f,
              count: 1
            }
          }
        }

        Integration::Purchases::CreateStats.call(year, month)

        expect(generated.data[:fornecedores]).to eq(expected_data[:fornecedores])
      end

      it 'grupos' do
        first = create(:integration_purchases_purchase, purchase_data)
        second = create(:integration_purchases_purchase, purchase_data)

        third_custom = { nome_grupo: "GRUPO NOVO" }
        third = create(:integration_purchases_purchase, purchase_data.merge(third_custom))

        ignored_out_of_range = create(:integration_purchases_purchase, purchase_old_date)

        expected_data = {
          grupos: {
            first.nome_grupo => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f*2,
              count: 2
            },
            third.nome_grupo => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f,
              count: 1
            }
          }
        }

        Integration::Purchases::CreateStats.call(year, month)

        expect(generated.data[:grupos]).to eq(expected_data[:grupos])
      end

      it 'resp_compra' do
        first = create(:integration_purchases_purchase, purchase_data)
        second = create(:integration_purchases_purchase, purchase_data)

        third_custom = { nome_resp_compra: "RESPONSAVEL NOVO" }
        third = create(:integration_purchases_purchase, purchase_data.merge(third_custom))

        ignored_out_of_range = create(:integration_purchases_purchase, purchase_old_date)

        expected_data = {
          resp_compra: {
            first.nome_resp_compra => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f*2,
              count: 2
            },
            third.nome_resp_compra => {
              valor_total_calculated: purchase_data[:valor_total_calculated].to_f,
              count: 1
            }
          }
        }

        Integration::Purchases::CreateStats.call(year, month)

        expect(generated.data[:resp_compra]).to eq(expected_data[:resp_compra])
      end
    end
  end
end
