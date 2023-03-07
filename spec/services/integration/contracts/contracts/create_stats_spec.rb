require 'rails_helper'

describe Integration::Contracts::Contracts::CreateStats do

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

        first = create(:integration_contracts_contract, contract_data)
        second = create(:integration_contracts_contract, contract_data)

        ignored_out_of_range = create(:integration_contracts_contract, contract_data.merge({data_assinatura: date - 2.years, data_termino: date - 1.year}))

        expected_data = {
          total: {
            valor_contrato: 1000,
            valor_atualizado_concedente: 200,
            count: 2
          }
        }

        Integration::Contracts::Contracts::CreateStats.call(year, month)

        generated = Stats::Contracts::Contract.find_by(year: year, month: month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'manager' do
        manager = create(:integration_supports_organ, orgao_sfp: false, codigo_orgao: '1234', codigo_folha_pagamento: nil)

        contract_data = base_contract_data.merge({
          cod_gestora: 1234
        })

        first = create(:integration_contracts_contract, contract_data)
        second = create(:integration_contracts_contract, contract_data)

        undefined_manager = create(:integration_contracts_contract, contract_data.merge({manager: nil}))

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

        Integration::Contracts::Contracts::CreateStats.call(year, month)

        generated = Stats::Contracts::Contract.find_by(year: year, month: month)

        expect(generated.data[:manager][manager.title]).to eq(expected_data[:manager][manager.title])
        expect(generated.data[:manager][I18n.t('messages.content.undefined')]).to eq(expected_data[:manager][I18n.t('messages.content.undefined')])
      end

      it 'creditor' do
        creditor = create(:integration_supports_creditor, cpf_cnpj: '1234')

        contract_data = base_contract_data.merge({
          cpf_cnpj_financiador: '1234'
        })

        first = create(:integration_contracts_contract, contract_data)
        second = create(:integration_contracts_contract, contract_data)

        undefined_creditor = create(:integration_contracts_contract, contract_data.merge({cpf_cnpj_financiador: '5678'}))

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

        Integration::Contracts::Contracts::CreateStats.call(year, month)

        generated = Stats::Contracts::Contract.find_by(year: year, month: month)

        expect(generated.data[:creditor][creditor.title]).to eq(expected_data[:creditor][creditor.title])
        expect(generated.data[:creditor][undefined_creditor.cpf_cnpj_financiador]).to eq(expected_data[:creditor][undefined_creditor.cpf_cnpj_financiador])
      end

      it 'tipo_objeto' do
        tipo_objeto = 'tipo 1'

        contract_data = base_contract_data.merge({
          tipo_objeto: tipo_objeto
        })

        first = create(:integration_contracts_contract, contract_data)
        second = create(:integration_contracts_contract, contract_data)

        undefined_tipo = create(:integration_contracts_contract, contract_data.merge({tipo_objeto: nil}))

        expected_data = {
          tipo_objeto: {
            first.tipo_objeto => {
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

        Integration::Contracts::Contracts::CreateStats.call(year, month)

        generated = Stats::Contracts::Contract.find_by(year: year, month: month)

        expect(generated.data[:tipo_objeto][tipo_objeto]).to eq(expected_data[:tipo_objeto][tipo_objeto])
        expect(generated.data[:tipo_objeto][I18n.t('messages.content.undefined')]).to eq(expected_data[:tipo_objeto][I18n.t('messages.content.undefined')])
      end

      it 'decricao_modalidade' do
        decricao_modalidade = 'modalidade 1'

        contract_data = base_contract_data.merge({
          decricao_modalidade: decricao_modalidade
        })

        first = create(:integration_contracts_contract, contract_data)
        second = create(:integration_contracts_contract, contract_data)

        undefined_tipo = create(:integration_contracts_contract, contract_data.merge({decricao_modalidade: nil}))

        expected_data = {
          decricao_modalidade: {
            first.decricao_modalidade => {
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


        Integration::Contracts::Contracts::CreateStats.call(year, month)

        generated = Stats::Contracts::Contract.find_by(year: year, month: month)

        expected_series_data_keys = [ first.decricao_modalidade, I18n.t('messages.content.undefined') ]

        expect(generated.data[:decricao_modalidade].keys).to eq(expected_series_data_keys)

        expect(generated.data[:decricao_modalidade][decricao_modalidade]).to eq(expected_data[:decricao_modalidade][decricao_modalidade])
        expect(generated.data[:decricao_modalidade][I18n.t('messages.content.undefined')]).to eq(expected_data[:decricao_modalidade][I18n.t('messages.content.undefined')])
      end
    end
  end
end
