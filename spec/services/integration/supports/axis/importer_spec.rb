require 'rails_helper'

describe Integration::Supports::Axis::Importer do

  let(:configuration) do
    create(:integration_supports_axis_configuration)
  end

  let(:service) { Integration::Supports::Axis::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Axis::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Axis::Importer.call(1)

      expect(Integration::Supports::Axis::Importer).to have_received(:new).with(1)
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
          consulta_eixos_response: {
            lista_eixos: {
              eixo: [
                {
                  codigo_eixo: '5',
                  descricao_eixo: 'CEARÁ DO CONHECIMENTO',
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
          with(:consulta_eixos, advanced_typecasting: false, message: message) { response }
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

      describe 'create axis' do
        let(:axis) { Integration::Supports::Axis.last }

        it { expect(axis.codigo_eixo).to eq('5') }
        it { expect(axis.descricao_eixo).to eq("CEARÁ DO CONHECIMENTO") }
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
          consulta_eixos_response: {
            lista_eixos: {
              eixo: [
                {
                  codigo_eixo: '5',
                  descricao_eixo: 'CEARÁ DO CONHECIMENTO',
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
          with(:consulta_eixos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'create axis' do
        let(:axis) { Integration::Supports::Axis.last }

        it { expect(axis.codigo_eixo).to eq('5') }
        it { expect(axis.descricao_eixo).to eq("CEARÁ DO CONHECIMENTO") }
      end
    end
  end
end
