require 'rails_helper'

describe Integration::Servers::ServerSalaries::CreateServerSalaries do

  let(:configuration) { create(:integration_servers_configuration, month: "#{current_month}/#{current_year}") }

  let(:service) { Integration::Servers::ServerSalaries::CreateServerSalaries.new(configuration.current_month) }

  let(:current_month) { 1 }
  let(:current_year) { 2017 }
  let(:current_date) { Date.new(current_year, current_month) }

  let(:another_month) { 10 }


  let(:organ) do
    create(:integration_supports_organ, orgao_sfp: true, codigo_folha_pagamento: '123')
  end

  let(:registration) do
    reg = create(:integration_servers_registration, cod_orgao: organ.codigo_folha_pagamento, dsc_matricula: '456')
    reg.update_attributes({cod_orgao: organ.codigo_folha_pagamento, full_matricula: '123/456'})
    reg
  end

  let(:proceed_data) do
    { cod_orgao: registration.cod_orgao, dsc_matricula: registration.dsc_matricula, num_ano: current_year, num_mes: current_month }
  end

  it 'creates server_salary with sums' do

    # considerar
    credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 100 }))
    another_credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 200 }))
    expect(credit.registration).to eq(registration)
    expect(another_credit.registration).to eq(registration)

    # ignorado pois de outro mes!
    ignored_credit = create(:integration_servers_proceed, :credit, proceed_data.merge({num_ano: current_year, num_mes: another_month, vlr_financeiro: 200 }))
    expect(ignored_credit.registration).to eq(registration)

    debit = create(:integration_servers_proceed, :debit, proceed_data.merge({ vlr_financeiro: 10 }))
    another_debit = create(:integration_servers_proceed, :debit, proceed_data.merge({ vlr_financeiro: 20 }))
    expect(debit.registration).to eq(registration)
    expect(another_debit.registration).to eq(registration)

    # dois cod_proventos representam abatimento do teto constitucional: 00662 e 662
    under_roof_type = create(:integration_servers_proceed_type, :debit, { cod_provento: '662' })
    another_under_roof_type = create(:integration_servers_proceed_type, :debit, { cod_provento: '00662' })
    under_roof_debit = create(:integration_servers_proceed, :debit, proceed_data.merge({ vlr_financeiro: 10, cod_provento: '662' }))
    another_under_roof_debit = create(:integration_servers_proceed, :debit, proceed_data.merge({ vlr_financeiro: 25, cod_provento: '00662' }))

    under_roof_debit.update_attribute(:cod_provento, '662')
    another_under_roof_debit.update_attribute(:cod_provento, '00662')

    # ignorado pois de outro mes!
    ignored_debit = create(:integration_servers_proceed, :debit, proceed_data.merge({num_ano: current_year, num_mes: another_month, vlr_financeiro: 200 }))
    expect(ignored_debit.registration).to eq(registration)

    expect do
      service.call

      server_salary = Integration::Servers::ServerSalary.last

      expected_date = current_date

      expect(server_salary.server_name). to eq(registration.dsc_funcionario)
      expect(server_salary.date). to eq(expected_date)
      expect(server_salary.registration). to eq(registration)
      expect(Integration::Servers::ServerSalary.statuses[server_salary.status]). to eq(registration.cod_situacao_funcional.to_i)
      expect(server_salary.role.name). to eq(registration.dsc_cargo)
      expect(server_salary.organ). to eq(registration.organ)

      # descontos 'abate teto'
      expected_discount_under_roof = under_roof_debit.vlr_financeiro + another_under_roof_debit.vlr_financeiro
      expect(server_salary.discount_under_roof). to eq(expected_discount_under_roof)

      # descontos 'outros'
      expected_discount_others = debit.vlr_financeiro + another_debit.vlr_financeiro
      expect(server_salary.discount_others). to eq(expected_discount_others)

      # descontos totais
      expected_discount_total = expected_discount_under_roof + expected_discount_others
      expect(server_salary.discount_total). to eq(expected_discount_total)

      # salário bruto
      expected_income_total = credit.vlr_financeiro + another_credit.vlr_financeiro
      expect(server_salary.income_total). to eq(expected_income_total)

      # salário líquido
      expected_income_final = expected_income_total - expected_discount_total
      expect(server_salary.income_final). to eq(expected_income_final)
    end.to change(Integration::Servers::ServerSalary, :count).by(1)
  end

  context 'income_dailies' do
    # coloca o zero antes do current_month pois precisamos testar que
    # 1/2017 não retornará diáries de 11/2017 pois a coluna em NED é uma
    # string.
    let(:data_emissao) { "10/0#{current_month}/#{current_year}" }
    let(:another_data_emissao) { "30/0#{current_month}/#{current_year}" }

    # é importante que seja 11/ para testar que não será contado qdo como
    # *1/2017 pois a coluna em Ned é string e não data.
    let(:data_emissao_ignore) { "10/11/#{current_year}" }

    # para os testes, só interessa testar o miolo da classificacao_orcamentaria
    let(:classificacao_prefix) { '02100001011285001740515' }
    let(:classificacao_suffix) { '001000002000' }

    context 'before 2016' do
      # para antes de 2016, é considerado diária se substring(28, 6) de
      # integration_expenses_neds.classificacao_orcamentaria_completo in ('339014','339015','449014','449015')

      let(:current_year) { 2015 }

      it 'calculates' do
        # considerar
        credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ num_ano: current_year, vlr_financeiro: 1000 }))
        cpf_formatted = registration.dsc_cpf


        # só devemos pegar as diárias de matrículas associadas ao órgão
        organ = registration.organ

        ned1 = create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000339014#{classificacao_suffix}")
        ned2 = create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000339015#{classificacao_suffix}")
        ned3 = create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000449014#{classificacao_suffix}")
        ned4 = create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000449015#{classificacao_suffix}")

        nld1 = create(:integration_expenses_nld, ned_composed_key: ned1.composed_key, numero_nota_empenho_despesa: ned1.numero, exercicio: 2015, exercicio_restos_a_pagar: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld2 = create(:integration_expenses_nld, ned_composed_key: ned2.composed_key, numero_nota_empenho_despesa: ned2.numero, exercicio: 2015, exercicio_restos_a_pagar: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld3 = create(:integration_expenses_nld, ned_composed_key: ned3.composed_key, numero_nota_empenho_despesa: ned3.numero, exercicio: 2015, exercicio_restos_a_pagar: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld4 = create(:integration_expenses_nld, ned_composed_key: ned4.composed_key, numero_nota_empenho_despesa: ned4.numero, exercicio: 2015, exercicio_restos_a_pagar: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao)

        npd1 = create(:integration_expenses_npd, valor: 10, nld_composed_key: nld1.composed_key, numero_nld_ordinaria: nld1.numero, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd2 = create(:integration_expenses_npd, valor: 20, nld_composed_key: nld2.composed_key, numero_nld_ordinaria: nld2.numero, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd3 = create(:integration_expenses_npd, valor: 40, nld_composed_key: nld3.composed_key, numero_nld_ordinaria: nld3.numero, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd4 = create(:integration_expenses_npd, valor: 50, nld_composed_key: nld4.composed_key, numero_nld_ordinaria: nld4.numero, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao, documento_credor: cpf_formatted)

        expect(npd1.nld).to eq(nld1)
        expect(npd2.nld).to eq(nld2)
        expect(npd3.nld).to eq(nld3)
        expect(npd4.nld).to eq(nld4)

        expect(nld1.ned).to eq(ned1)
        expect(nld2.ned).to eq(ned2)
        expect(nld3.ned).to eq(ned3)
        expect(nld4.ned).to eq(ned4)

        # ignorar

        ## fora da data de emissao
        create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao_ignore, valor_pago: 60, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000339014#{classificacao_suffix}")

        ## de outra unidade gestora
        create(:integration_expenses_ned, exercicio: 2015, unidade_gestora: '456', data_emissao: another_data_emissao, valor_pago: 60, classificacao_orcamentaria_completo: "#{classificacao_prefix}00000339014#{classificacao_suffix}")

        expect do
          service.call

          expected = (10 + 20 + 40 + 50)

          server_salary = Integration::Servers::ServerSalary.first

          expect(server_salary.income_dailies).to eq(expected)
        end.to change(Integration::Servers::ServerSalary, :count).by(1)
      end
    end

    context '2016 and after' do
      # para 2016 e depois, é considerado diária se substring(24, 6) de
      # integration_expenses_neds.classificacao_orcamentaria_completo in ('339014','339015','449014','449015')

      let(:current_year) { 2016 }

      it 'calculates' do
        # considerar
        credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 1000 }))
        cpf_formatted = registration.dsc_cpf

        # só devemos pegar as diárias de matrículas associadas ao órgão
        organ = registration.organ

        ned1 = create(:integration_expenses_ned, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}339014#{classificacao_suffix}")
        ned2 = create(:integration_expenses_ned, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}339015#{classificacao_suffix}")
        ned3 = create(:integration_expenses_ned, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}449014#{classificacao_suffix}")
        ned4 = create(:integration_expenses_ned, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao, classificacao_orcamentaria_completo: "#{classificacao_prefix}449015#{classificacao_suffix}")

        nld1 = create(:integration_expenses_nld, ned_composed_key: ned1.composed_key, numero_nota_empenho_despesa: ned1.numero, exercicio: 2016, exercicio_restos_a_pagar: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld2 = create(:integration_expenses_nld, ned_composed_key: ned2.composed_key, numero_nota_empenho_despesa: ned2.numero, exercicio: 2016, exercicio_restos_a_pagar: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld3 = create(:integration_expenses_nld, ned_composed_key: ned3.composed_key, numero_nota_empenho_despesa: ned3.numero, exercicio: 2016, exercicio_restos_a_pagar: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao)
        nld4 = create(:integration_expenses_nld, ned_composed_key: ned4.composed_key, numero_nota_empenho_despesa: ned4.numero, exercicio: 2016, exercicio_restos_a_pagar: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao)

        npd1 = create(:integration_expenses_npd, valor: 10, nld_composed_key: nld1.composed_key, numero_nld_ordinaria: nld1.numero, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd2 = create(:integration_expenses_npd, valor: 20, nld_composed_key: nld2.composed_key, numero_nld_ordinaria: nld2.numero, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd3 = create(:integration_expenses_npd, valor: 40, nld_composed_key: nld3.composed_key, numero_nld_ordinaria: nld3.numero, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: data_emissao, documento_credor: cpf_formatted)
        npd4 = create(:integration_expenses_npd, valor: 50, nld_composed_key: nld4.composed_key, numero_nld_ordinaria: nld4.numero, exercicio: 2016, unidade_gestora: registration.organ.codigo_orgao, data_emissao: another_data_emissao, documento_credor: cpf_formatted)

        expect(npd1.nld).to eq(nld1)
        expect(npd2.nld).to eq(nld2)
        expect(npd3.nld).to eq(nld3)
        expect(npd4.nld).to eq(nld4)

        expect(nld1.ned).to eq(ned1)
        expect(nld2.ned).to eq(ned2)
        expect(nld3.ned).to eq(ned3)
        expect(nld4.ned).to eq(ned4)

        expect do
          service.call

          expected = (10 + 20 + 40 + 50)

          server_salary = Integration::Servers::ServerSalary.from_server(registration.server).first

          expect(server_salary.income_dailies).to eq(expected)
        end.to change(Integration::Servers::ServerSalary, :count).by(1)
      end
    end
  end

  it 'does not duplicate server_salary' do
    create(:integration_servers_proceed, num_ano: current_year, num_mes: current_month, vlr_financeiro: 10)

    service.call

    expect do
      service.call
    end.to change(Integration::Servers::ServerSalary, :count).by(0)
  end

  it 'updates server_salary' do
    proceed = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 10 }))

    service.call

    expect(Integration::Servers::ServerSalary.last.income_total). to eq(10)

    expect do
      create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 20 }))

      service.call

      expected = 30.0

      expect(Integration::Servers::ServerSalary.last.income_total). to eq(expected)

    end.to change(Integration::Servers::ServerSalary, :count).by(0)
  end

  it 'creates organ-role association' do
    credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 100 }))

    service.call

    server_salary = Integration::Servers::ServerSalary.last

    expect(server_salary.organ.roles).to eq([server_salary.role])
  end

  it 'ignores if organ.orgao_sfp is false' do
    credit = create(:integration_servers_proceed, :credit, proceed_data.merge({ vlr_financeiro: 100 }))

    organ.orgao_sfp = false

    organ.save

    expect do
      service.call

      server_salary = Integration::Servers::ServerSalary.last

    end.to change(Integration::Servers::ServerSalary, :count).by(0)
  end

  it 'remover server_salaries with 0 income_final and 0 income_total' do
    first = create(:integration_servers_server_salary, date: current_date, income_total: 0, income_final: 0)
    second = create(:integration_servers_server_salary, date: current_date, income_total: 0, income_final: 1)
    third = create(:integration_servers_server_salary, date: current_date, income_total: 1, income_final: 0)

    service.call

    expect(Integration::Servers::ServerSalary.all).to match_array([second, third])
  end

  it 'create_server_salaries_stats' do
    month = current_date.month
    year = current_date.year

    expect(Integration::Servers::ServerSalaries::CreateStats).to receive(:call).with(year, month)

    service.call
  end

  it 'generates server_salaries spreadsheet' do
    month = current_date.month
    year = current_date.year

    expect(Integration::Servers::ServerSalaries::CreateSpreadsheet).to receive(:call).with(year, month)

    service.call
  end
end
