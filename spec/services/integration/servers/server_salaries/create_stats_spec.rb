require 'rails_helper'

describe Integration::Servers::ServerSalaries::CreateStats do

  describe 'totals' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }
    let(:date) { Date.today.beginning_of_month }

    describe 'data' do

      it 'total' do
        salary_data = {
          date: date,
          income_total: 500,
          income_final: 250,
          income_dailies: 50,
          discount_total: 250,
          discount_under_roof: 50,
          discount_others: 200
        }

        #first = create(:integration_servers_server_salary, salary_data)
        #second = create(:integration_servers_server_salary, salary_data)

        n = 5
        n.times do 
          create(:integration_servers_server_salary, salary_data)
        end

        salary_data[:date] = date + 2.months
        from_another_month = create(:integration_servers_server_salary, salary_data)

        # expected_data = {
        #   total: {
        #     income_total: 1000, # bruto
        #     income_final: 500, # líquido
        #     income_dailies: 100, # diárias
        #     discount_total: 500, # descontos
        #     discount_under_roof: 100, # 'abate teto'
        #     discount_others: 400, # outros descontos
        #     unique_count: 2,
        #     count: 2
        #   }
        # }


        expected_data = {
          total: {
            income_total: 500*n, # bruto
            income_final: 250*n, # líquido
            income_dailies: 50*n, # diárias
            discount_total: 250*n, # descontos
            discount_under_roof: 50*n, # 'abate teto'
            discount_others: 200*n, # outros descontos
            unique_count: n,
            count: n
          }
        }

        Integration::Servers::ServerSalaries::CreateStats.call(year, month)

        generated = Stats::ServerSalary.find_by(year: year, month: month)

        expect(generated.data[:total]).to eq(expected_data[:total])
      end

      it 'functional_status_value' do
        salary_data = {
          date: date,
          income_total: 500,
          income_final: 250,
          income_dailies: 50,
          discount_total: 250,
          discount_under_roof: 50,
          discount_others: 200
        }

        active_cod_situacao_funcional = 0
        inactive_cod_situacao_funcional = 7

        active_registration = create(:integration_servers_registration, cod_situacao_funcional: active_cod_situacao_funcional, status_situacao_funcional: "ATIVO")
        inactive_registration = create(:integration_servers_registration, cod_situacao_funcional: inactive_cod_situacao_funcional)

        first = create(:integration_servers_server_salary, salary_data.merge({registration: active_registration}))
        second = create(:integration_servers_server_salary, salary_data.merge({registration: inactive_registration}))

        # deixamos apenas alguns itens pro expected_data não conter todos os códigos com as contagens zeradas.
        stub_const('Integration::Servers::Registration::COD_SITUATION_ACTIVE', [0, 1])
        stub_const('Integration::Servers::Registration::COD_SITUATION_INACTIVE', [6])

        expected_data = {
          functional_status: {
            I18n.t("integration/servers/registration.functional_statuses.functional_status_active") => {
              income_total: 500, # bruto
              income_final: 250, # líquido
              income_dailies: 50, # diárias
              discount_total: 250, # descontos
              discount_under_roof: 50, # 'abate teto'
              discount_others: 200, # outros descontos
              count: 1,
              unique_count: 1
            },

            I18n.t("integration/servers/registration.functional_statuses.functional_status_retired") => {
              income_total: 0,
              income_final: 0,
              income_dailies: 0,
              discount_total: 0,
              discount_under_roof: 0,
              discount_others: 0,
              count: 0,
              unique_count: 0
            },

            I18n.t("integration/servers/registration.functional_statuses.functional_status_pensioner") => {
              income_total: 0,
              income_final: 0,
              income_dailies: 0,
              discount_total: 0,
              discount_under_roof: 0,
              discount_others: 0,
              count: 0,
              unique_count: 0
            },

            I18n.t("integration/servers/registration.functional_statuses.functional_status_intern") => {
              income_total: 0,
              income_final: 0,
              income_dailies: 0,
              discount_total: 0,
              discount_under_roof: 0,
              discount_others: 0,
              count: 0,
              unique_count: 0
            }
          }
        }

        Integration::Servers::ServerSalaries::CreateStats.call(year, month)

        generated = Stats::ServerSalary.find_by(year: year, month: month)

        expect(generated.data[:functional_status]).to eq(expected_data[:functional_status])
      end
    end

    it 'counts by server, not by registration' do
      salary_data = {
        date: date,
        income_total: 500,
        income_final: 250,
        income_dailies: 50,
        discount_total: 250,
        discount_under_roof: 50,
        discount_others: 200
      }

      first = create(:integration_servers_server_salary, salary_data)

      another_registration = create(:integration_servers_registration, server: first.server)
      second = create(:integration_servers_server_salary, salary_data.merge(registration: another_registration))

      expect(first.registration).not_to eq(second.registration)
      expect(first.registration.server).to eq(second.registration.server)

      expected_data = {
        total: {
          income_total: 1000, # bruto
          income_final: 500, # líquido
          income_dailies: 100, # diárias
          discount_total: 500, # descontos
          discount_under_roof: 100, # 'abate teto'
          discount_others: 400, # outros descontos
          count: 2,
          unique_count: 1 # deve contar apenas 1 servidor, apesar de duas matrículas.
        }
      }

      Integration::Servers::ServerSalaries::CreateStats.call(year, month)

      generated = Stats::ServerSalary.find_by(year: year, month: month)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'organ' do
      salary_data = {
        date: date,
        income_total: 500,
        income_final: 250,
        income_dailies: 50,
        discount_total: 250,
        discount_under_roof: 50,
        discount_others: 200
      }

      active_cod_situacao_funcional = '0'
      inactive_cod_situacao_funcional = '7'

      active_registration = create(:integration_servers_registration, cod_situacao_funcional: active_cod_situacao_funcional)
      inactive_registration = create(:integration_servers_registration, cod_situacao_funcional: inactive_cod_situacao_funcional)

      first = create(:integration_servers_server_salary, salary_data.merge({registration: active_registration}))
      second = create(:integration_servers_server_salary, salary_data.merge({registration: inactive_registration}))

      undefined_organ = create(:integration_servers_server_salary, salary_data)
      undefined_organ.organ.destroy
      undefined_organ.reload

      first_organ = active_registration.organ
      second_organ = inactive_registration.organ


      another_active_registration = create(:integration_servers_registration, cod_situacao_funcional: active_cod_situacao_funcional)
      another_from_organ = create(:integration_servers_server_salary, salary_data.merge({registration: another_active_registration}))

      another_active_registration.cod_orgao = first_organ.codigo_folha_pagamento
      another_active_registration.save
      another_from_organ.reload

      inactive_registration.cod_orgao = second_organ.codigo_folha_pagamento
      second.save

      expected_data = {
        organ: {
          first_organ.sigla => {
            title: first_organ.title,
            income_total: 1000, # bruto
            income_final: 500, # líquido
            income_dailies: 100, # diárias
            discount_total: 500, # descontos
            discount_under_roof: 100, # 'abate teto'
            discount_others: 400, # outros descontos
            count: 2,
            unique_count: 2
          },

          I18n.t('messages.content.undefined') => {
            income_total: 500, # bruto
            income_final: 250, # líquido
            income_dailies: 50, # diárias
            discount_total: 250, # descontos
            discount_under_roof: 50, # 'abate teto'
            discount_others: 200, # outros descontos
            count: 1,
            unique_count: 1
          }
        }
      }

      expect(active_registration.organ).to eq(first_organ)
      expect(another_active_registration.organ).to eq(first_organ)
      expect(inactive_registration.organ).to eq(second_organ)
      expect(undefined_organ.registration.organ).to eq(nil)

      expect(first.organ).to eq(first_organ)
      expect(another_from_organ.organ).to eq(first_organ)
      expect(second.organ).to eq(second_organ)
      expect(undefined_organ.organ).to eq(nil)

      Integration::Servers::ServerSalaries::CreateStats.call(year, month)

      generated = Stats::ServerSalary.find_by(year: year, month: month)

      expect(generated.data[:organ][first_organ.sigla]).to eq(expected_data[:organ][first_organ.sigla])
      expect(generated.data[:organ][second_organ.sigla]).to eq(expected_data[:organ][second_organ.sigla])
      expect(generated.data[:organ][I18n.t('messages.content.undefined')]).to eq(expected_data[:organ][I18n.t('messages.content.undefined')])
    end

    it 'role' do
      salary_data = {
        date: date,
        income_total: 500,
        income_final: 250,
        income_dailies: 50,
        discount_total: 250,
        discount_under_roof: 50,
        discount_others: 200
      }

      active_cod_situacao_funcional = '0'
      inactive_cod_situacao_funcional = '7'

      active_registration = create(:integration_servers_registration, cod_situacao_funcional: active_cod_situacao_funcional)
      inactive_registration = create(:integration_servers_registration, cod_situacao_funcional: inactive_cod_situacao_funcional)

      first = create(:integration_servers_server_salary, salary_data.merge({registration: active_registration}))
      second = create(:integration_servers_server_salary, salary_data.merge({registration: inactive_registration}))

      undefined_role = create(:integration_servers_server_salary, salary_data.merge({role: nil}))

      first_role = first.role
      second_role = second.role

      another_from_role = create(:integration_servers_server_salary, salary_data.merge({role: first_role}))

      expected_data = {
        role: {
          first_role.name => {
            title: first_role.title,
            income_total: 1000, # bruto
            income_final: 500, # líquido
            income_dailies: 100, # diárias
            discount_total: 500, # descontos
            discount_under_roof: 100, # 'abate teto'
            discount_others: 400, # outros descontos
            count: 2,
            unique_count: 2
          },

          I18n.t('messages.content.undefined') => {
            income_total: 500, # bruto
            income_final: 250, # líquido
            income_dailies: 50, # diárias
            discount_total: 250, # descontos
            discount_under_roof: 50, # 'abate teto'
            discount_others: 200, # outros descontos
            count: 1,
            unique_count: 1
          }
        }
      }

      Integration::Servers::ServerSalaries::CreateStats.call(year, month)

      generated = Stats::ServerSalary.find_by(year: year, month: month)

      expect(generated.data[:role][first_role.name]).to eq(expected_data[:role][first_role.name])
      expect(generated.data[:role][second_role.name]).to eq(expected_data[:role][second_role.name])
      expect(generated.data[:role][I18n.t('messages.content.undefined')]).to eq(expected_data[:role][I18n.t('messages.content.undefined')])
    end
  end
end
