require 'rails_helper'

describe Integration::Contracts::DailyUpdater do

  let(:configuration) { create(:integration_contracts_configuration) }

  # os órgão com orgao_sfp são usados apenas na folha de pagamento (Servidores)
  # temos que garantir que a relação de órgãos seja feita com o orgao_sfp=false
  # pois há duplicação de órgãos (com e sem orgao_sfp).

  let(:sfp_manager) { create(:integration_supports_organ, codigo_orgao: '240401', orgao_sfp: true) }
  let(:manager) { create(:integration_supports_organ, codigo_orgao: '240401', orgao_sfp: false) }

  let(:grantor) { create(:integration_supports_management_unit, codigo: '240001') }

  let(:creditor) { create(:integration_supports_creditor, cpf_cnpj: '05268526000170') }

  let(:date) { Date.parse('01/01/2017') }

  let(:service) { Integration::Contracts::DailyUpdater.new(configuration.id, date) }

  let(:contrato) do
    {
      :cod_concedente=>"240001",
      :cod_financiador=>"187710",
      :cod_gestora=>"240401",
      :cod_orgao=>"24200004",
      :cod_secretaria=>"24000000",
      :decricao_modalidade=>"DISPENSA",
      :descricao_objeto=>"Celebrar CONTRATO DE GESTÃO com o instituto de Saúde e Gestão hospitalar - ISGH com o objetivo de operacionalizar a gestão  execução das atividades e serviços de saúde a serem desenvolvidos desenvolvidos no Hospital Regional Norte, no Ano de 2016.",
      :descricao_tipo=>"CONTRATO",
      :descricao_url=>"20160129.978601.Integra.CONTRATO.pdf",
      :data_assinatura=> '01/02/2017',
      :data_processamento=> '15/02/2017',
      :data_termino=> '01/02/2018',
      :flg_tipo=>"49",
      :isn_parte_destino=>"189748",
      :isn_sic=>"978601",
      :num_spu=>"7521010/2015",
      :valor_contrato=>"27169976.25",
      :isn_modalidade=>"0",
      :isn_entidade=>"1795",
      :tipo_objeto=>"Outros",
      :num_spu_licitacao=>"75210102-0",
      :descricao_justificativa=>"Manutenção da Unidade Hospitalar, Hospital Regional do Norte.",
      :valor_can_rstpg=>"0",
      :data_publicacao_portal=> DateTime.now,
      :data_publicacao_doe=> DateTime.now - 1.day,
      :descricao_url_pltrb=>"Sem Pltrb",
      :descricao_url_inexg=>"Sem DecInexg",
      :cod_plano_trabalho=>nil,
      :num_certidao=>"407523",
      :descriaco_edital=>"01. PROCESSO LICITATÓRIO",
      :cpf_cnpj_financiador=>"05.268.526/0001-70",
      :num_contrato=>"03/2016",
      :valor_original_concedente=>"27169976.25",
      :valor_original_contrapartida=>"0",
      :valor_atualizado_concedente=>"27169976.25",
      :valor_atualizado_contrapartida=>"0",
      :descricao_nome_credor=> 'Credor...',
      :data_auditoria=> '01/01/2017'
    }
  end

  let(:contrato_response) do
    {
      consulta_contratos_convenios_atualizados_response: {
        lista_contratos_convenios_atualizados: {
          contrato_convenio: [contrato]
        }
      }
    }
  end

  let(:contrato_message) do
    {
      usuario: configuration.user,
      senha: configuration.password,
      data_instrumento: '01/01/2017'
    }
  end

  before do
    contract_response = double()
    allow(service.client).to receive(:call).
      with(:consulta_contratos_convenios_atualizados, advanced_typecasting: false, message: contrato_message) { contract_response }
    allow(contract_response).to receive(:body) { contrato_response }
  end

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Contracts::DailyUpdater).to receive(:new).with(1, nil) { service }
      allow(service).to receive(:call)
      Integration::Contracts::DailyUpdater.call(1)

      expect(Integration::Contracts::DailyUpdater).to have_received(:new).with(1, nil)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to client' do
      expect(service.client).to be_an_instance_of(Savon::Client)
    end

    it 'responds to configuration' do
      expect(service.configuration).to eq(configuration)
    end
  end

  describe 'date'  do
    it 'sets date of parameter' do
      expect(service.date).to eq(date)
    end

    it 'sets default date to 1 day ago' do
      service = Integration::Contracts::DailyUpdater.new(configuration.id)

      expect(service.date).to eq(Date.today - 1.day)
    end
  end

  describe 'call' do
    before do
      allow(service).to receive(:import_contracts)
      allow(service).to receive(:import_additives)
      allow(service).to receive(:import_adjustments)
      allow(service).to receive(:import_financials)
      allow(service).to receive(:import_infringements)

      service.call
    end
    it 'invokes import_contracts' do
      expect(service).to have_received(:import_contracts)
    end
    it 'invokes import_additives' do
      expect(service).to have_received(:import_additives)

    end
    it 'invokes import_adjustments' do
      expect(service).to have_received(:import_adjustments)

    end
    it 'invokes import_financials' do
      expect(service).to have_received(:import_financials)

    end
    it 'invokes import_infringements' do
      expect(service).to have_received(:import_infringements)

    end

    describe 'statuses' do
      it 'success' do
        service.call
        expect(configuration.reload.status_success?).to be_truthy
      end

      describe 'error' do
        before do
          allow(service).to receive(:import_contracts) { raise 'Error' }
          service.call
          configuration.reload
        end

        it { expect(configuration.status_fail?).to be_truthy }

      end
    end
  end

  describe 'import_contracts' do
    it 'creates contracts' do
      expect do
        service.send(:start)
        service.send(:import_contracts)

        created_contract = Integration::Contracts::Convenant.last

        expect(created_contract.infringement_status).to eq('adimplente')

        expect(created_contract.data_publicacao_doe.to_date).to eq(contrato[:data_publicacao_doe].to_date)
        expect(created_contract.descricao_nome_credor).to eq(contrato[:descricao_nome_credor])

        expect(created_contract.data_auditoria.to_date).to eq(contrato[:data_auditoria].to_date)

      end.to change(Integration::Contracts::Convenant, :count).by(1)
    end
  end

  describe 'import_additives' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        data_aditivo: '01/01/2017'
      }
    end

    let(:body) do
      {
        consulta_aditivos_atualizados_response: {
          lista_aditivos_atualizados: {
            aditivo: [additive]
          }
        }
      }
    end

    let(:additive) do
      {
        :descricao_observacao=>"Constitui objeto do presente Aditivo a prorrogação do prazo do Termo de Cooperação Financeira nº 284/2016, referente ao Projeto ¿Leitura ao Pé do Ouvido¿, que passará a ter o prazo de vigência até 31 de março de 2017, nos moldes descritos no novo plano de trabalho (fls. 06 a 11) devidamente aprovado pelo SIP (fl. 12) do processo nº 0068951/2017.",
        :descricao_tipo_aditivo=>"Prorrogação",
        :descricao_url=>"~/UploadArquivos/20170220.1000061.Integra.1ºADITIVO.PDF",
        :data_aditivo=> Date.current,
        :data_inicio=> Date.current,
        :data_publicacao=> Date.current,
        :data_termino=> Date.current,
        :flg_tipo_aditivo=>"49",
        :isn_contrato_aditivo=>"407986",
        :isn_ig=>"915171",
        :isn_sic=>"978601",
        :valor_acrescimo=>"0",
        :valor_reducao=>"0",
        :data_publicacao_portal=> Date.current,
        :num_aditivo_siconv=>"1270",
        :data_auditoria=> '01/01/2017'
      }
    end

    before do
      response = double()
      allow(service.client).to receive(:call).
        with(:consulta_aditivos_atualizados, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'organs' do
      manager
      grantor

      sfp_manager

      service.send(:import_contracts)
      contract = Integration::Contracts::Convenant.last

      expect(contract.manager).to eq(manager)
      expect(contract.grantor).to eq(grantor)
    end

    it 'creditor' do
      creditor

      service.send(:import_contracts)
      contract = Integration::Contracts::Convenant.last
      expect(contract.creditor).to eq(creditor)
    end

    it 'assigns contract' do
      expect do

        service.send(:import_contracts)
        service.send(:import_additives)

        contract = Integration::Contracts::Convenant.last
        aditivo = Integration::Contracts::Additive.last

        expect(aditivo.contract).to eq(contract)

        created = Integration::Contracts::Additive.last
        expect(created.data_auditoria.to_date).to eq(additive[:data_auditoria].to_date)
        expect(Integration::Contracts::Additive.count).to eq(1)


      end.to change(Integration::Contracts::Convenant, :count).by(1)
    end

    it 'sums in contract' do
      service.send(:import_contracts)
      service.send(:import_additives)
      service.send(:calculate_sums)

      contract = Integration::Contracts::Convenant.last

      expect(contract.calculated_valor_ajuste).to eq(contract.additives.total_addition)
    end

  end

  describe 'import_adjustments' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        data_ajuste: '01/01/2017'
      }
    end

    let(:body) do
      {
        consulta_apostilamentos_atualizados_response: {
          lista_apostilamentos_atualizados: {
            apostilamento: [adjustment]
          }
        }
      }
    end

    let(:adjustment) do
      {
        :descricao_observacao=>"APOSTILAMENTO PARA PRORROGAÇÃO DE OFÍCIO AO CONVÊNIO 013/2015 COM A ENTIDADE SOCIEDADE PARA O BEM ESTAR DA FAMÍLIA -SOBEF, DESTINADO A MANUTENÇÃO E FUNCIONAMENTO DA UNIDADE CENTRO SOCIOEDUCATIVO DO CANINDEZINHO.",
        :descricao_tipo_ajuste=>"PRORROGAÇÃO DE OFÍCIO",
        :data_ajuste=> Date.current,
        :data_alteracao=> Date.current,
        :data_exclusao=> Date.current,
        :data_inclusao=> Date.current,
        :data_inicio=> Date.current,
        :data_termino=> Date.current,
        :flg_acrescimo_reducao=>"65",
        :flg_controle_transmissao=>"83",
        :flg_receita_despesa=>"65",
        :flg_tipo_ajuste=>"68",
        :isn_contrato_ajuste=>"97155",
        :isn_contrato_tipo_ajuste=>"1",
        :ins_edital=>"912524",
        :isn_sic=>"978601",
        :isn_situacao=>"502",
        :isn_usuario_alteracao=>"0",
        :isn_usuario_aprovacao=>"217210",
        :isn_usuario_auditoria=>"1132",
        :isn_usuario_exclusao=>"0",
        :valor_ajuste_destino=>"0",
        :valor_ajuste_origem=>"0",
        :valor_inicio_destino=>"0",
        :valor_inicio_origem=>"0",
        :valor_termino_origem=>"0",
        :valor_termino_destino=>"0",
        :descricao_url=>"~/UploadArquivos/20170127.968340.Ajuste.97155AJUSTE.PDF",
        :num_apostilamento_siconv=>nil,
        :data_auditoria=> '01/01/2017'
      }
    end

    before do
      response = double()
      allow(service.client).to receive(:call).
        with(:consulta_apostilamentos_atualizados, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'assigns contract' do
      expect do

        service.send(:import_contracts)
        service.send(:import_adjustments)

        contract = Integration::Contracts::Convenant.last
        ajuste = Integration::Contracts::Adjustment.last

        expect(ajuste.contract).to eq(contract)

        created = Integration::Contracts::Adjustment.last
        expect(created.data_auditoria.to_date).to eq(adjustment[:data_auditoria].to_date)
        expect(Integration::Contracts::Adjustment.count).to eq(1)

      end.to change(Integration::Contracts::Convenant, :count).by(1)
    end

    it 'sums in contract' do
      service.send(:import_contracts)
      service.send(:import_adjustments)
      service.send(:calculate_sums)

      contract = Integration::Contracts::Convenant.last

      expect(contract.calculated_valor_ajuste).to eq(contract.adjustments.total_adjustments)
    end

    it 'only sums for changed contracts' do

      another = create(:integration_contracts_contract)

      service.send(:import_contracts)
      service.send(:import_adjustments)
      service.send(:calculate_sums)

      contract = Integration::Contracts::Convenant.last

      another.reload

      expect(another.calculated_valor_ajuste).to eq(nil)
      expect(contract.calculated_valor_ajuste).to eq(contract.adjustments.total_adjustments)
    end
  end

  describe 'import_financials' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        data_documento: '01/01/2017'
      }
    end

    let(:body) do
      {
        consulta_financeiros_atualizados_response: {
          lista_financeiros_atualizados: {
            financeiro: [financial]
          }
        }
      }
    end

    let(:financial) do
      {
        :ano_documento=>"2017",
        :cod_entidade=>"24200214",
        :cod_fonte=>"91",
        :cod_gestor=>"241291",
        :descricao_entidade=>"HOSPITAL DE MESSEJANA",
        :descricao_objeto=>"Aquisição de material médico hospitalar, cateter diagnóstico, para suprir as necessidades do HMCASG.",
        :data_documento=> Date.current,
        :data_pagamento=> Date.current,
        :data_processamento=> Date.current,
        :flg_sic=>"83",
        :isn_sic=>"978601",
        :num_documento=>"00348",
        :valor_documento=>"1800",
        :valor_pagamento=>"0",
        :cod_credor=>"131830",
        :data_auditoria=> '01/01/2017'
      }
    end

    before do
      response = double()
      allow(service.client).to receive(:call).
        with(:consulta_financeiros_atualizados, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'creates financials' do
      expect do
        service.send(:import_financials)

        created = Integration::Contracts::Financial.last

        expect(created.data_auditoria.to_date).to eq(financial[:data_auditoria].to_date)

      end.to change(Integration::Contracts::Financial, :count).by(1)
    end

    it 'assigns contract' do
      expect do

        service.send(:import_contracts)
        service.send(:import_financials)

        contract = Integration::Contracts::Convenant.last
        financeiro = Integration::Contracts::Financial.last

        expect(financeiro.contract).to eq(contract)
      end.to change(Integration::Contracts::Convenant, :count).by(1)
    end

    it 'sums in contract' do
      service.send(:import_contracts)
      service.send(:import_financials)
      service.send(:calculate_sums)

      contract = Integration::Contracts::Convenant.last

      expect(contract.calculated_valor_empenhado).to eq(contract.valor_empenhado)
      expect(contract.calculated_valor_pago).to eq(contract.valor_pago)
    end
  end

  describe 'import_infringements' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password
      }
    end

    let(:body) do
      {
        consulta_inadimplencia_response: {
          lista_inadimplencia: {
            inadimplencia: [infringement]
          }
        }
      }
    end

    let(:infringement) do
      {
        :cod_financiador=>"860147",
        :cod_gestora=>"220001",
        :descricao_entidade=>"SECRETARIA DA EDUCAÇÃO",
        :descricao_financiador=>"PREF MUNIC DE QUIXERE",
        :descricao_motivo_inadimplencia=>"SEM PRESTAÇÃO DE CONTAS",
        :data_lancamento=> Date.current,
        :data_processamento=> Date.current,
        :data_termino_atual=> Date.current,
        :data_ultima_pcontas=> Date.current,
        :data_ultima_pagto=> Date.current,
        :isn_sic=>"978601",
        :qtd_pagtos=>"4",
        :valor_atualizado_total=>"288713.57",
        :valor_inadimplencia=>"72179.57",
        :valor_liberacoes=>"288713.57",
        :valor_pcontas_acomprovar=>"0",
        :valor_pcontas_apresentada=>"0",
        :valor_pcontas_aprovada=>"0"
      }
    end

    before do
      response = double()
      allow(service.client).to receive(:call).
        with(:consulta_inadimplencia, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'creates infringements' do
      expect do
        service.send(:import_contracts)
        service.send(:import_infringements)
      end.to change(Integration::Contracts::Infringement, :count).by(1)
    end

    it 'assigns contract' do
      expect do
        service.send(:import_contracts)
        service.send(:import_infringements)

        contract = Integration::Contracts::Convenant.last
        inadimplencia = Integration::Contracts::Infringement.last

        expect(inadimplencia.contract).to eq(contract)

        expect(contract.infringement_status).to eq('inadimplente')

      end.to change(Integration::Contracts::Convenant, :count).by(1)
    end
  end

  describe 'stats' do
    let(:body) { {} }

    before do
      response = double()
      allow(service.client).to receive(:call).with(any_args).and_return(response)
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    describe 'change monitoring' do
      let(:body) do
        {
          consulta_contratos_convenios_atualizados_response: {
            lista_contratos_convenios_atualizados: {
              contrato_convenio: [
                contrato, # convenio
                contrato.merge({ isn_sic: "978602", data_assinatura: '01/01/2017', flg_tipo: '51' }), # contrato
              ]
            }
          }
        }
      end

      it 'only create_stats when new data is imported' do
        # Só chamamos a estatística nos períodos em que houve alteração nos dados

        expect(Integration::Contracts::Contracts::CreateStats).to receive(:call).with(2017, 1)
        expect(Integration::Contracts::Contracts::CreateStats).not_to receive(:call).with(2017, 2)
        expect(Integration::Contracts::Contracts::CreateStats).not_to receive(:call).with(2017, 3)

        expect(Integration::Contracts::ManagementContracts::CreateStats).to receive(:call).with(2017, 1)
        expect(Integration::Contracts::ManagementContracts::CreateStats).not_to receive(:call).with(2017, 2)
        expect(Integration::Contracts::ManagementContracts::CreateStats).not_to receive(:call).with(2017, 3)

        expect(Integration::Contracts::Convenants::CreateStats).to receive(:call).with(2017, 2)
        expect(Integration::Contracts::Convenants::CreateStats).not_to receive(:call).with(2017, 1)
        expect(Integration::Contracts::Convenants::CreateStats).not_to receive(:call).with(2017, 3)


        service.call
      end
    end
  end

  describe 'stats' do
    let(:body) { {} }

    before do
      response = double()
      allow(service.client).to receive(:call).with(any_args).and_return(response)
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    describe 'change monitoring' do
      let(:body) do
        {
          consulta_contratos_convenios_atualizados_response: {
            lista_contratos_convenios_atualizados: {
              contrato_convenio: [
                contrato, # convenio
                contrato.merge({ isn_sic: "978602", data_assinatura: '01/01/2017', flg_tipo: '51' }), # contrato
              ]
            }
          }
        }
      end

      it 'only create_stats when new data is imported' do
        # Só chamamos a estatística nos períodos em que houve alteração nos dados

        expect(Integration::Contracts::Contracts::CreateSpreadsheet).to receive(:call).with(2017, 1)
        expect(Integration::Contracts::Contracts::CreateSpreadsheet).not_to receive(:call).with(2017, 2)
        expect(Integration::Contracts::Contracts::CreateSpreadsheet).not_to receive(:call).with(2017, 3)

        expect(Integration::Contracts::ManagementContracts::CreateSpreadsheet).to receive(:call).with(2017, 1)
        expect(Integration::Contracts::ManagementContracts::CreateSpreadsheet).not_to receive(:call).with(2017, 2)
        expect(Integration::Contracts::ManagementContracts::CreateSpreadsheet).not_to receive(:call).with(2017, 3)

        expect(Integration::Contracts::Convenants::CreateSpreadsheet).to receive(:call).with(2017, 2)
        expect(Integration::Contracts::Convenants::CreateSpreadsheet).not_to receive(:call).with(2017, 1)
        expect(Integration::Contracts::Convenants::CreateSpreadsheet).not_to receive(:call).with(2017, 3)


        service.call
      end
    end
  end
end
