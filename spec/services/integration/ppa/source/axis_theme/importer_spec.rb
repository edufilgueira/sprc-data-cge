require 'rails_helper'

describe Integration::PPA::Source::AxisTheme::Importer do

  let(:configuration) do
    create(:integration_ppa_source_axis_theme_configuration)
  end

  let(:service) { Integration::PPA::Source::AxisTheme::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::PPA::Source::AxisTheme::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::PPA::Source::AxisTheme::Importer.call(1)

      expect(Integration::PPA::Source::AxisTheme::Importer).to have_received(:new).with(1)
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
          eixos_temas_response: {
            lista_eixos_temas: {
              eixos_temas: [
                {
                  codigo_eixo: '1',
                  descricao_eixo: 'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS',
                  codigo_tema: '1.01',
                  descricao_tema: '-',
                  descricao_tema_detalhado: ''
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
          with(:eixos_temas, advanced_typecasting: false, message: message) { response }
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
        let(:axis_theme) { PPA::Source::AxisTheme.last }

        it { expect(axis_theme.codigo_eixo).to eq('1') }
        it { expect(axis_theme.descricao_eixo).to eq('CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS') }
        it { expect(axis_theme.codigo_tema).to eq('1.01') }
        it { expect(axis_theme.descricao_tema).to eq('-') }
      end
    end
  end
end
