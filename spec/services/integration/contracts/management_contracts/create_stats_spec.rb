require 'rails_helper'

describe Integration::Contracts::ManagementContracts::CreateStats do
  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    let(:base_contract_data) do
      {
        data_assinatura: date - 1.year,
        data_termino: date + 2.years,
        valor_contrato: 500,
        valor_atualizado_concedente: 100,
      }
    end

    describe 'data' do
      it 'total' do
        contract_data = base_contract_data

        first = create(:integration_contracts_contract, :management, contract_data)
        second = create(:integration_contracts_contract, :management, contract_data)

        ignored_out_of_range = create(:integration_contracts_contract, :management, contract_data.merge({data_assinatura: date - 2.years, data_termino: date - 1.year}))

        expected_data = {
          total: {
            valor_contrato: 1000,
            valor_atualizado_concedente: 200,
            count: 2
          }
        }

        Integration::Contracts::ManagementContracts::CreateStats.call(year, month)

        generated = Stats::Contracts::ManagementContract.find_by(year: year, month: month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'manager' do
        manager = create(:integration_supports_organ, orgao_sfp: false, codigo_orgao: '1234', codigo_folha_pagamento: nil)

        contract_data = base_contract_data.merge({
          cod_gestora: 1234
        })

        first = create(:integration_contracts_contract, :management, contract_data)
        second = create(:integration_contracts_contract, :management, contract_data)

        undefined_manager = create(:integration_contracts_contract, :management, contract_data.merge({manager: nil}))

        expected_data = {
          manager: {
            manager.title => {
              title: manager.title,
              valor_contrato: 1000,
              valor_atualizado_concedente: 200,
              count: 2
            },

            I18n.t('messages.content.undefined') => {
              valor_contrato: 500,
              valor_atualizado_concedente: 100,
              count: 1
            }
          }
        }

        Integration::Contracts::ManagementContracts::CreateStats.call(year, month)

        generated = Stats::Contracts::ManagementContract.find_by(year: year, month: month)

        expect(generated.data[:manager][manager.title]).to eq(expected_data[:manager][manager.title])
        expect(generated.data[:manager][I18n.t('messages.content.undefined')]).to eq(expected_data[:manager][I18n.t('messages.content.undefined')])
      end

      it 'creditor' do
        creditor = create(:integration_supports_creditor, cpf_cnpj: '1234')

        contract_data = base_contract_data.merge({
          cpf_cnpj_financiador: '1234'
        })

        first = create(:integration_contracts_contract, :management, contract_data)
        second = create(:integration_contracts_contract, :management, contract_data)

        undefined_creditor = create(:integration_contracts_contract, :management, contract_data.merge({cpf_cnpj_financiador: '5678'}))

        expected_data = {
          creditor: {
            creditor.title => {
              title: creditor.title,
              valor_contrato: 1000,
              valor_atualizado_concedente: 200,
              count: 2
            },

            undefined_creditor.cpf_cnpj_financiador => {
              valor_contrato: 500,
              valor_atualizado_concedente: 100,
              count: 1
            }
          }
        }

        Integration::Contracts::ManagementContracts::CreateStats.call(year, month)

        generated = Stats::Contracts::ManagementContract.find_by(year: year, month: month)

        expect(generated.data[:creditor][creditor.title]).to eq(expected_data[:creditor][creditor.title])
        expect(generated.data[:creditor][undefined_creditor.cpf_cnpj_financiador]).to eq(expected_data[:creditor][undefined_creditor.cpf_cnpj_financiador])
      end
    end
  end
end
