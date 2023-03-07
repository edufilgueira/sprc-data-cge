require 'rails_helper'

describe Integration::Expenses::NpfImporter do

  let(:configuration) { create(:integration_expenses_configuration) }

  let!(:organ) { create(:integration_supports_management_unit, codigo: '220001') }
  let!(:creditor) { create(:integration_supports_creditor, codigo: '00123') }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Expenses::NpfImporter.new(configuration, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::NpfImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Expenses::NpfImporter.call(1, logger)

      expect(Integration::Expenses::NpfImporter).to have_received(:new).with(1, logger)
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
          consulta_nota_programacao_financeira_response: {
            nota_programacao_financeira: [
              {
                exercicio: "2017",
                unidade_gestora: "220001",
                unidade_executora: "220001",
                numero: "00034110",
                numero_npf_ord: nil,
                natureza: "ORDINARIA",
                tipo_proc_adm_desp: "ORCAMENTARIO",
                efeito: ["DESEMBOLSO", nil],
                data_emissao: "25/08/2017",
                grupo_fin: "35",
                fonte_rec: "28282",
                valor: "0.00",
                credor: "00123",
                codigo_projeto: "2200010542017I",
                numero_parcela: "56",
                isn_parcela: "1457014",
                numeroconvenio: "00000001004855",
                data_atual: "19/09/2017"
              }
            ]
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.ned_user,
          senha: configuration.ned_password,
          data_inicio: configuration.started_at.to_s,
          data_fim: configuration.finished_at.to_s
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_nota_programacao_financeira, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end


      it 'imports data' do
        npf = Integration::Expenses::Npf.last

        expect(npf.exercicio).to eq (2017)
        expect(npf.unidade_gestora).to eq ("220001")
        expect(npf.unidade_executora).to eq ("220001")
        expect(npf.numero).to eq ("00034110")
        expect(npf.numero_npf_ord).to eq (nil)
        expect(npf.natureza).to eq ("ORDINARIA")
        expect(npf.tipo_proc_adm_desp).to eq ("ORCAMENTARIO")
        expect(npf.efeito).to eq ('["DESEMBOLSO", nil]')
        expect(npf.data_emissao).to eq ("25/08/2017")
        expect(npf.grupo_fin).to eq ("35")
        expect(npf.fonte_rec).to eq ("28282")
        expect(npf.valor).to eq (0.00)
        expect(npf.credor).to eq ("00123")
        expect(npf.codigo_projeto).to eq ("2200010542017I")
        expect(npf.numero_parcela).to eq ("56")
        expect(npf.isn_parcela).to eq ("1457014")
        expect(npf.numeroconvenio).to eq ("00000001004855")
        expect(npf.data_atual).to eq ("19/09/2017")

        expect(npf.management_unit).to eq(organ)
        expect(npf.executing_unit).to eq (organ)
        expect(npf.creditor).to eq (creditor)
      end
    end
  end

  describe 'stats' do
    let(:body) { {} }

    let(:configuration) { create(:integration_expenses_configuration, started_at: '01/01/2017', finished_at: '03/03/2017' ) }

    before do
      response = double()
      allow(service.client).to receive(:call).with(any_args).and_return(response)
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'create_stats' do
      # espera que chame estatística para todos os meses do intervalo no parâmetro
      # de configuração.
      expect(Integration::Expenses::Npfs::CreateStats).to receive(:call).with(2017, 1)
      expect(Integration::Expenses::Npfs::CreateStats).to receive(:call).with(2017, 2)
      expect(Integration::Expenses::Npfs::CreateStats).to receive(:call).with(2017, 3)


      service.call
    end
  end
end
