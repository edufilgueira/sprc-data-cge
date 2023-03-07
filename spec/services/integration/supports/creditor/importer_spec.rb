require 'rails_helper'

describe Integration::Supports::Creditor::Importer do

  let(:configuration) do
    create(:integration_supports_creditor_configuration)
  end

  let(:service) { Integration::Supports::Creditor::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Creditor::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Creditor::Importer.call(1)

      expect(Integration::Supports::Creditor::Importer).to have_received(:new).with(1)
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
          consulta_credor_response: {
            credor: [
              {
                bairro: 'Centro',
                cep: '63570000',
                codigo: '000123',
                codigo_contribuinte: 'X',
                codigo_distrito: nil,
                codigo_municipio: '2300804',
                codigo_nit: nil,
                codigo_pis_pasep: nil,
                complemento: 'RUA JOÃO BATISTA ARRAIS, Nº 08',
                cpf_cnpj: '07594500000148',
                data_atual: '25/09/2017',
                data_cadastro: '25/09/2017',
                email: 'prefeituramunicipalantonina@hotmail.com',
                logradouro: 'ROSENO DE MATOS',
                nome: 'PREFEITURA MUNICIPAL DE ANTONINA DO NORTE',
                nome_municipio: 'Antonina do Norte',
                numero: '0',
                status: 'Ativo',
                telefone_contato: '8835251322',
                uf: 'CE'
              }
            ]
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.user,
          senha: configuration.password,
          filtro: {
            data_inicio: configuration.started_at.to_s,
            data_fim: configuration.finished_at.to_s,
            pagina: ''
          }
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_credor, advanced_typecasting: false, message: message) { response }
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

      describe 'create creditor' do
        let(:creditor) { Integration::Supports::Creditor.last }

        it { expect(creditor.bairro).to eq('Centro') }
        it { expect(creditor.cep).to eq('63570000') }
        it { expect(creditor.codigo).to eq('000123') }
        it { expect(creditor.codigo_contribuinte).to eq('X') }
        it { expect(creditor.codigo_distrito).to be_nil }
        it { expect(creditor.codigo_municipio).to eq('2300804') }
        it { expect(creditor.codigo_nit).to be_nil }
        it { expect(creditor.codigo_pis_pasep).to be_nil }
        it { expect(creditor.complemento).to eq('RUA JOÃO BATISTA ARRAIS, Nº 08') }
        it { expect(creditor.cpf_cnpj).to eq('07594500000148') }
        it { expect(creditor.data_atual).to eq('25/09/2017') }
        it { expect(creditor.data_cadastro).to eq('25/09/2017') }
        it { expect(creditor.email).to eq('prefeituramunicipalantonina@hotmail.com') }
        it { expect(creditor.logradouro).to eq('ROSENO DE MATOS') }
        it { expect(creditor.nome).to eq('PREFEITURA MUNICIPAL DE ANTONINA DO NORTE') }
        it { expect(creditor.nome_municipio).to eq('Antonina do Norte') }
        it { expect(creditor.numero).to eq('0') }
        it { expect(creditor.status).to eq('Ativo') }
        it { expect(creditor.telefone_contato).to eq('8835251322') }
        it { expect(creditor.uf).to eq('CE') }

      end
    end
  end

end
