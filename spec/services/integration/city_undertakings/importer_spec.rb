require 'rails_helper'

describe Integration::CityUndertakings::Importer do

  let!(:contract) { create(:integration_contracts_contract, isn_sic: 616997) }
  let(:configuration) { create(:integration_city_undertakings_configuration) }

  let(:year) { Date.current.year }
  let(:month) { Date.current.month }
  let(:empreendimento_name) { "RODOVIAS DO PROGRAMA CEARÁ III" }

  let(:service) { Integration::CityUndertakings::Importer.new(configuration.id) }

  let!(:organ) { create(:integration_supports_organ, sigla: 'ISSEC', orgao_sfp: false) }
  let!(:sfp_organ) { create(:integration_supports_organ, sigla: 'ISSEC', orgao_sfp: true) }
  let!(:creditor) { create(:integration_supports_creditor) }

  let!(:city) { double("City", name: 'CANINDÉ') }

  before do
    allow(State).to receive_message_chain(:default, :cities) { [city] }
  end

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::CityUndertakings::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::CityUndertakings::Importer.call(1)

      expect(Integration::CityUndertakings::Importer).to have_received(:new).with(1)
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
    let(:city_name) { city.name }

    describe 'xml response' do
      let(:body) do
        {
          consulta_empreendimentos_response: {
            lista_empreendimentos: {
              empreendimento: [
                {
                  descricao: "#{empreendimento_name}    "
                }
              ]
            }
          }
        }
      end

      let(:empty_body) do
        {
          consulta_empreendimentos_response: {
            lista_municipios_empreendimentos: nil
          }
        }
      end

      let(:city_undertaking_body) do
        {
          consulta_municipios_empreendimentos_response: {
            lista_municipios_empreendimentos: {
              municipio_empreendimento: {
                municipio: "CANINDÉ     ",
                tipo_despesa: "CONVENIO",
                sic: "616997   ",
                mapp: "APOIO AOS APL 2009   ",
                credor: "#{creditor.title} - #{creditor.cpf_cnpj}  ",
                empreendimento: "#{empreendimento_name}    ",
                orgao: "#{organ.sigla}     ",
                valor_programado1: 0,
                valor_programado2: 0,
                valor_programado3: 0,
                valor_programado4: 75000,
                valor_programado5: 0,
                valor_programado6: 0,
                valor_programado7: 105000,
                valor_programado8: 0,
                valor_executado1: 0,
                valor_executado2: 0,
                valor_executado3: 0,
                valor_executado4: 85000,
                valor_executado5: 0,
                valor_executado6: 0,
                valor_executado7: 105000,
                valor_executado8: 0,
              }
            }
          }
        }
      end

      let(:default_message) do
        { usuario: configuration.user, senha: configuration.password }
      end

      let(:message)       { default_message }

      let(:city_undertaking_message) do
        default_message.merge(municipio: city_name, empreendimento: empreendimento_name)
      end

      before do
        response, empty_response, city_undertaking_response = double(), double(), double()

        allow(service.client).to receive(:call).
          with(:consulta_empreendimentos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        allow(service.client).to receive(:call).
          with(:consulta_municipios_empreendimentos, advanced_typecasting: false, message: city_undertaking_message) { city_undertaking_response }
        allow(city_undertaking_response).to receive(:body) { city_undertaking_body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let!(:body) { empty_body }

        it { expect(Integration::Supports::Undertaking.count).to eq(0) }
        it { expect(Integration::CityUndertakings::CityUndertaking.count).to eq(0) }
      end

      describe 'creates Undertaking' do
        it { expect(Integration::Supports::Undertaking.count).to eq(1) }
      end

      describe 'create city_undertaking' do
        it { expect(Integration::CityUndertakings::CityUndertaking.count).to eq(1) }
      end

      describe 'associations' do
        let(:city_undertaking) { Integration::CityUndertakings::CityUndertaking.last }

        describe 'creditor' do
          it { expect(city_undertaking.creditor).to eq(creditor) }
        end

        describe 'create occupation_type' do
          let(:undertaking) { Integration::Supports::Undertaking.last }
          it { expect(city_undertaking.undertaking).to eq(undertaking) }
        end

        describe 'organ' do
          it { expect(city_undertaking.organ).to eq(organ) }
        end
      end

      describe 'with items = Array' do
        describe 'create city_undertaking' do
          let(:city_undertaking) { Integration::CityUndertakings::CityUndertaking.last }

          it { expect(city_undertaking.municipio).to eq "CANINDÉ" }
          it { expect(city_undertaking.tipo_despesa).to eq "CONVENIO" }
          it { expect(city_undertaking.convenant?).to be_truthy }
          it { expect(city_undertaking.sic).to eq 616997 }
          it { expect(city_undertaking.mapp).to eq "APOIO AOS APL 2009" }
          it { expect(city_undertaking.valor_programado1).to eq 0 }
          it { expect(city_undertaking.valor_programado2).to eq 0 }
          it { expect(city_undertaking.valor_programado3).to eq 0 }
          it { expect(city_undertaking.valor_programado4).to eq 75000 }
          it { expect(city_undertaking.valor_programado5).to eq 0 }
          it { expect(city_undertaking.valor_programado6).to eq 0 }
          it { expect(city_undertaking.valor_programado7).to eq 105000 }
          it { expect(city_undertaking.valor_programado8).to eq 0 }
          it { expect(city_undertaking.valor_executado1).to eq 0 }
          it { expect(city_undertaking.valor_executado2).to eq 0 }
          it { expect(city_undertaking.valor_executado3).to eq 0 }
          it { expect(city_undertaking.valor_executado4).to eq 85000 }
          it { expect(city_undertaking.valor_executado5).to eq 0 }
          it { expect(city_undertaking.valor_executado6).to eq 0 }
          it { expect(city_undertaking.valor_executado7).to eq 105000 }
          it { expect(city_undertaking.valor_executado8).to eq 0 }
        end
      end
    end
  end
end
