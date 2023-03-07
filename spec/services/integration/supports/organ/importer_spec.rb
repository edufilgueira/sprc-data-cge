require 'rails_helper'

describe Integration::Supports::Organ::Importer do

  let(:configuration) do
    create(:integration_supports_organ_configuration)
  end

  let(:service) { Integration::Supports::Organ::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Organ::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Organ::Importer.call(1)

      expect(Integration::Supports::Organ::Importer).to have_received(:new).with(1)
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

  let(:organs_ws_attributes) do
    [
      {
        :codigo_orgao=>"240001",
        :descricao_orgao=>"SECRETARIA DA SAÚDE",
        :sigla=>"SESA",
        :codigo_entidade=>"24000000",
        :descricao_entidade=>"SECRETARIA DA SAÚDE",
        :descricao_administracao=>"DIRETA",
        :poder=>"EXECUTIVO",
        :codigo_folha_pagamento=>nil,
        :data_inicio=>nil,
        :data_termino=>'Mon, 30 Apr 2007 00:00:00 -0300',
        :orgao_sfp=>false
      },
      {
        :codigo_orgao=>"240001",
        :descricao_orgao=>"SECRETARIA DA SAÚDE",
        :sigla=>"SESA",
        :codigo_entidade=>"24000000",
        :descricao_entidade=>"SECRETARIA DA SAÚDE",
        :descricao_administracao=>"DIRETA",
        :poder=>"EXECUTIVO",
        :codigo_folha_pagamento=>nil,
        :data_inicio=>nil,
        :data_termino=>nil,
        :orgao_sfp=>false
      },
      {
        :codigo_orgao=>"240001",
        :descricao_orgao=>"SECRETARIA DA SAÚDE",
        :sigla=>"SESA",
        :codigo_entidade=>"24000000",
        :descricao_entidade=>"SECRETARIA DA SAÚDE",
        :descricao_administracao=>"DIRETA",
        :poder=>"EXECUTIVO",
        :codigo_folha_pagamento=>nil,
        :data_inicio=>nil,
        :data_termino=>'Thu, 17 May 2007 00:00:00 -0300',
        :orgao_sfp=>false
      },
      {
        :codigo_orgao=>"240001",
        :descricao_orgao=>"SECRETARIA DA SAÚDE",
        :sigla=>"SESA",
        :codigo_entidade=>"24000000",
        :descricao_entidade=>"SECRETARIA DA SAÚDE",
        :descricao_administracao=>"DIRETA",
        :poder=>"EXECUTIVO",
        :codigo_folha_pagamento=>nil,
        :data_inicio=>nil,
        :data_termino=>'Thu, 10 May 2007 00:00:00 -0300',
        :orgao_sfp=>false
      },
      {
        :codigo_orgao=>"240001",
        :descricao_orgao=>"SECRETARIA DA SAÚDE",
        :sigla=>"SESA",
        :codigo_entidade=>nil,
        :descricao_entidade=>nil,
        :descricao_administracao=>nil,
        :poder=>nil,
        :codigo_folha_pagamento=>"241",
        :data_inicio=>nil,
        :data_termino=>nil,
        :orgao_sfp=>true
      }
    ]
  end

  describe 'call' do
    describe 'xml response' do
      let(:body) do
        {
          consulta_orgaos_response: {
            lista_orgao: {
              orgao: organs_ws_attributes
            }
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.user,
          senha: configuration.password,
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_orgaos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end


      describe 'statuses' do
        it { expect(configuration.status_success?).to be_truthy }

        describe 'error' do
          before do
            allow(service).to receive(:import_resource) { raise 'Error' }
            service.call
            configuration.reload
          end

          it { expect(configuration.status_fail?).to be_truthy }
        end
      end

      it 'create new organs' do
        expect(Integration::Supports::Organ.count).to eq(5)

        first_organ = Integration::Supports::Organ.first
        expect(first_organ.codigo_orgao).to eq("240001")
        expect(first_organ.descricao_orgao).to eq("SECRETARIA DA SAÚDE")
        expect(first_organ.sigla).to eq("SESA")
        expect(first_organ.codigo_entidade).to eq("24000000")
        expect(first_organ.descricao_entidade).to eq("SECRETARIA DA SAÚDE")
        expect(first_organ.descricao_administracao).to eq("DIRETA")
        expect(first_organ.poder).to eq("EXECUTIVO")
        expect(first_organ.codigo_folha_pagamento).to eq(nil)
        expect(first_organ.data_inicio).to eq(nil)
        expect(first_organ.data_termino).to eq(Date.parse('Mon, 30 Apr 2007'))
        expect(first_organ.orgao_sfp).to eq(false)

        last_organ = Integration::Supports::Organ.last
        expect(last_organ.codigo_orgao).to eq("240001")
        expect(last_organ.descricao_orgao).to eq("SECRETARIA DA SAÚDE")
        expect(last_organ.sigla).to eq("SESA")
        expect(last_organ.codigo_entidade).to eq(nil)
        expect(last_organ.descricao_entidade).to eq(nil)
        expect(last_organ.descricao_administracao).to eq(nil)
        expect(last_organ.poder).to eq(nil)
        expect(last_organ.codigo_folha_pagamento).to eq("241")
        expect(last_organ.data_inicio).to eq(nil)
        expect(last_organ.data_termino).to eq(nil)
        expect(last_organ.orgao_sfp).to eq(true)
      end

      it 'only update' do
        #
        # chamando o serviço pela segunda vez depois do 'before'
        #
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_orgaos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }
        #
        #
        #

        organs_ws_attributes.first[:sigla] = 'SESAS'
        organs_ws_attributes.first[:descricao_orgao] = 'Outra descrição da Secretaria da saúde'
        organs_ws_attributes.first[:codigo_entidade] = '11111'
        organs_ws_attributes.first[:descricao_entidade] = 'Outra descrição da Secretaria da saúde'
        organs_ws_attributes.first[:descricao_administracao] = 'INDIRETA'
        organs_ws_attributes.first[:poder] = 'LEGISLATIVO'
        organs_ws_attributes.first[:data_inicio] = Date.today
        organs_ws_attributes.first[:organ_sfp] = false

        #
        # the same unique key
        #
        organs_ws_attributes.first[:codigo_orgao] = '240001'
        organs_ws_attributes.first[:data_termino] = nil
        organs_ws_attributes.first[:codigo_folha_pagamento] = '241'
        #
        #
        #

        service.call

        expect(Integration::Supports::Organ.count).to eq(5)
      end

      it 'data_termino changed on WS' do
        #
        # chamando o serviço pela segunda vez depois do 'before'
        #
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_orgaos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }
        #
        #
        #

        #
        # unique key was changed
        #
        organs_ws_attributes.first[:codigo_orgao] = '240001'
        organs_ws_attributes.first[:codigo_folha_pagamento] = '123'
        organs_ws_attributes.first[:data_termino] = Date.today
        #
        #
        #

        service.call

        expect(Integration::Supports::Organ.count).to eq(6)
      end
    end

    #
    # Temos que garantir que se houver adição de colunas no webservice, o
    # importador não irá falhar ao tentar atribuir seu valor, como quando usado
    # o update_attributes, ou o assign_attributes.
    #
    describe 'accepts unknow attributes' do
      let(:body) do
        {
          consulta_orgaos_response: {
            lista_orgao: {
              orgao: [
                {
                  codigo_orgao: '081001',
                  descricao_orgao: 'SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA',
                  sigla: 'SEDURB',
                  codigo_entidade: '08000000',
                  descricao_entidade: 'SECRETARIA DA INFRAESTRUTURA',
                  descricao_administracao: 'INDIRETA',
                  poder: 'EXECUTIVO',
                  codigo_folha_pagamento: nil,
                  novo_campo: ''
                }
              ]
            }
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.user,
          senha: configuration.password,
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_orgaos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'create organ' do
        let(:organ) { Integration::Supports::Organ.last }

        it { expect(organ.codigo_orgao).to eq("081001") }
        it { expect(organ.descricao_orgao).to eq("SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA") }
        it { expect(organ.sigla).to eq("SEDURB") }
        it { expect(organ.codigo_entidade).to eq("08000000") }
        it { expect(organ.descricao_entidade).to eq("SECRETARIA DA INFRAESTRUTURA") }
        it { expect(organ.descricao_administracao).to eq("INDIRETA") }
        it { expect(organ.poder).to eq("EXECUTIVO") }
        it { expect(organ.codigo_folha_pagamento).to be_nil }
      end
    end
  end
end
