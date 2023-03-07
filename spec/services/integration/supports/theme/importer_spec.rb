require 'rails_helper'

describe Integration::Supports::Theme::Importer do

  let(:configuration) do
    create(:integration_supports_theme_configuration)
  end

  let(:service) { Integration::Supports::Theme::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Theme::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Theme::Importer.call(1)

      expect(Integration::Supports::Theme::Importer).to have_received(:new).with(1)
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
          consulta_temas_response: {
            lista_temas: {
              tema: [
                {
                  codigo_tema: '1.02',
                  descricao_tema: 'PLANEJAMENTO E GESTÃO',
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
          with(:consulta_temas, advanced_typecasting: false, message: message) { response }
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

      describe 'create theme' do
        let(:theme) { Integration::Supports::Theme.last }

        it { expect(theme.codigo_tema).to eq('1.02') }
        it { expect(theme.descricao_tema).to eq("PLANEJAMENTO E GESTÃO") }
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
          consulta_temas_response: {
            lista_temas: {
              tema: [
                {
                  codigo_tema: '1.02',
                  descricao_tema: 'PLANEJAMENTO E GESTÃO',
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
          with(:consulta_temas, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'create theme' do
        let(:theme) { Integration::Supports::Theme.last }

        it { expect(theme.codigo_tema).to eq('1.02') }
        it { expect(theme.descricao_tema).to eq("PLANEJAMENTO E GESTÃO") }
      end
    end
  end
end
