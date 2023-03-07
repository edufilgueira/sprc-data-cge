require 'rails_helper'

describe Integration::PPA::Source::Region::Importer do

  let(:configuration) do
    create(:integration_ppa_source_region_configuration)
  end

  let(:service) { Integration::PPA::Source::Region::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::PPA::Source::Region::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::PPA::Source::Region::Importer.call(1)

      expect(Integration::PPA::Source::Region::Importer).to have_received(:new).with(1)
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
          regioes_response: {
            lista_regioes: {
              regioes: [
                {
                  codigo_regiao: '01',
                  descricao_regiao: 'CARIRI'
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
          with(:regioes, advanced_typecasting: false, message: message) { response }
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

      describe 'create region' do
        let(:region) { PPA::Source::Region.last }

        it { expect(region.codigo_regiao).to eq('01') }
        it { expect(region.descricao_regiao).to eq('CARIRI') }
      end
    end
  end
end
