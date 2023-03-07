require 'rails_helper'

describe Integration::RealStates::Importer do

  let(:configuration) { create(:integration_real_states_configuration) }

  let(:year) { Date.current.year }
  let(:month) { Date.current.month }

  let(:service) { Integration::RealStates::Importer.new(configuration.id) }

  let!(:manager) { create(:integration_supports_organ, sigla: 'ISSEC', orgao_sfp: false) }
  let!(:sfp_manager) { create(:integration_supports_organ, sigla: 'ISSEC', orgao_sfp: true) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::RealStates::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::RealStates::Importer.call(1)

      expect(Integration::RealStates::Importer).to have_received(:new).with(1)
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

  describe 'call' do
    describe 'xml response' do
      let(:body) do
        {
          consulta_imoveis_response: {
            lista_imoveis: {
              imovel: [
                {
                  id: "6",
                  descricao_imovel: "TERRENO-ISSEC-FORTALEZA",
                  municipio: "Fortaleza",
                  entidade: "INSTITUTO DE SAÚDE DOS SERVIDORES DO ESTADO DO CEARÁ"
                }
              ]
            }
          }
        }
      end

      let(:empty_body) do
        {
          consulta_imoveis_response: {
            lista_imoveis: {
              imovel: []
            }
          }
        }
      end

      let(:detail_body) do
        {
          detalha_imovel_response: {
            imovel: {
              id: "6",
              descricao_imovel: "TERRENO-ISSEC-FORTALEZA",
              estado: "CEARÁ",
              municipio: "Fortaleza",
              sigla_orgao: "ISSEC         ",
              entidade: "INSTITUTO DE SAÚDE DOS SERVIDORES DO ESTADO DO CEARÁ",
              area_projecao_construcao: "54.4",
              area_medida_in_loco: "486.0",
              area_registrada: "0.0",
              frente: "12",
              fundo: "12",
              lateral_direita: "40.5",
              lateral_esquerda: "40.5",
              taxa_ocupacao: "11.19",
              fracao_ideal: "1.0",
              tipo_imovel: "Terreno",
              tipo_ocupacao: "Outros",
              numero_imovel: nil,
              utm_zona: "24",
              bairro: nil,
              cep: "60.823-110",
              endereco: "RUA MELO CÉSAR, ESQ. COM RUA ESCRIVÃO AZEVEDO",
              complemento: "-",
              lote: "10",
              quadra: "15"
            }
          }
        }
      end

      let(:default_message) do
        { usuario: configuration.user, senha: configuration.password }
      end

      let(:message)         { default_message.merge({ pagina: 1, limite: 180 }) }
      let(:second_message)  { default_message.merge({ pagina: 2, limite: 180 }) }
      let(:empty_message)   { message.merge(pagina: 2) }
      let(:detail_message)  { default_message.merge(id: '6') }

      before do
        response, empty_response, detail_response = double(), double(), double()

        allow(service.client).to receive(:call).
          with(:consulta_imoveis, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        allow(service.client).to receive(:call).and_raise(StandardError.new("error")).with(:consulta_imoveis, advanced_typecasting: false, message: second_message) { response }

        allow(service.client).to receive(:call).
          with(:detalha_imovel, advanced_typecasting: false, message: detail_message) { detail_response }
        allow(detail_response).to receive(:body) { detail_body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) { empty_body }

        it { expect(Integration::RealStates::RealState.count).to eq(0) }
      end

      describe 'create real_state' do
        it { expect(Integration::RealStates::RealState.count).to eq(1) }
      end

      describe 'associations' do
        let(:real_state) { Integration::RealStates::RealState.last }

        describe 'create property_type' do
          it { expect(real_state.property_type.title).to eq("Terreno") }
          it { expect(Integration::Supports::RealStates::PropertyType.count).to eq(1) }
        end

        describe 'create occupation_type' do
          it { expect(real_state.occupation_type.title).to eq("Outros") }
          it { expect(Integration::Supports::RealStates::OccupationType.count).to eq(1) }
        end

        describe 'unidade_gestora' do
          it { expect(real_state.manager).to eq(manager) }
        end
      end

      describe 'with items = Array' do
        describe 'create real_state' do
          let(:real_state) { Integration::RealStates::RealState.last }

          it { expect(real_state.service_id).to eq("6") }
          it { expect(real_state.descricao_imovel).to eq("TERRENO-ISSEC-FORTALEZA") }
          it { expect(real_state.estado).to eq("CEARÁ") }
          it { expect(real_state.municipio).to eq("Fortaleza") }
          it { expect(real_state.area_projecao_construcao).to eq("54.4".to_d) }
          it { expect(real_state.area_medida_in_loco).to eq("486.0".to_d) }
          it { expect(real_state.area_registrada).to eq("0.0".to_d) }
          it { expect(real_state.frente).to eq("12".to_d) }
          it { expect(real_state.fundo).to eq("12".to_d) }
          it { expect(real_state.lateral_direita).to eq("40.5".to_d) }
          it { expect(real_state.lateral_esquerda).to eq("40.5".to_d) }
          it { expect(real_state.taxa_ocupacao).to eq("11.19".to_d) }
          it { expect(real_state.fracao_ideal).to eq("1.0".to_d) }
          it { expect(real_state.numero_imovel).to be_nil }
          it { expect(real_state.utm_zona).to eq("24") }
          it { expect(real_state.bairro).to be_nil }
          it { expect(real_state.cep).to eq("60.823-110") }
          it { expect(real_state.endereco).to eq("RUA MELO CÉSAR, ESQ. COM RUA ESCRIVÃO AZEVEDO") }
          it { expect(real_state.complemento).to eq("-") }
          it { expect(real_state.lote).to eq("10") }
          it { expect(real_state.quadra).to eq("15") }
        end
      end
    end
  end
end
