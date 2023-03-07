require 'rails_helper'

describe Integration::Expenses::NpdImporter do
  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let!(:organ) { create(:integration_supports_management_unit, codigo: '101021') }
  let!(:creditor) { create(:integration_supports_creditor, codigo: '00004600') }

  let!(:nld) { create(:integration_expenses_nld, exercicio: 2017, unidade_gestora: '101021', numero: '00011129') }

  let(:service) { Integration::Expenses::NpdImporter.new(configuration, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::NpdImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Expenses::NpdImporter.call(1, logger)

      expect(Integration::Expenses::NpdImporter).to have_received(:new).with(1, logger)
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
          consulta_nota_pagamento_despesa_response: {
            nota_pagamento_despesa: [
              {
                exercicio: "2017",
                unidade_gestora: "101021",
                unidade_executora: "101021",
                numero: "00011129",
                codigo_retencao: "15",
                natureza: "ORDINARIA",
                justificativa: "RECOLHIMENTO REFERENTE A TERCEIRIZAÇÃO",
                efeito: "DESEMBOLSO",
                numero_processo_administrativo_despesa: "79665",
                data_emissao: "20/01/2017",
                credor: "00004600",
                documento_credor: "07.954.605/0001-60",
                valor: "15168.94",
                numero_nld_ordinaria: "00011129",
                servico_bancario: "Autenticação Bancária",
                banco_origem: "104",
                agencia_origem: "0919",
                digito_agencia_origem: "9",
                conta_origem: "0060701600",
                digito_conta_origem: "5",
                banco_pagamento: "104",
                banco_beneficiario: "104",
                agencia_beneficiario: "0919",
                digito_agencia_beneficiario: "9",
                conta_beneficiario: "0060000180",
                digito_conta_beneficiario: "0",
                status_movimento_bancario: "CONFIRMADO",
                data_retorno_remessa_bancaria: "25/08/2017",
                data_atual: "20/09/2017"
              }
            ]
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.npd_user,
          senha: configuration.npd_password,
          data_inicio: configuration.started_at.to_s,
          data_fim: configuration.finished_at.to_s
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_nota_pagamento_despesa, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_nota_pagamento_despesa_response: { } }
        end

        it { expect(Integration::Expenses::Npd.count).to eq(0) }
      end

      describe 'create npd' do
        let(:npd) { Integration::Expenses::Npd.last }

        it { expect(Integration::Expenses::Npd.count).to eq(1) }
      end

      describe 'with items = Array' do
        it 'imports data' do
          npd = Integration::Expenses::Npd.last

          expect(npd.exercicio).to eq(2017)
          expect(npd.unidade_gestora).to eq("101021")
          expect(npd.unidade_executora).to eq("101021")
          expect(npd.numero).to eq("00011129")
          expect(npd.codigo_retencao).to eq("15")
          expect(npd.natureza).to eq("ORDINARIA")
          expect(npd.justificativa).to eq("RECOLHIMENTO REFERENTE A TERCEIRIZAÇÃO")
          expect(npd.efeito).to eq("DESEMBOLSO")
          expect(npd.numero_processo_administrativo_despesa).to eq("79665")
          expect(npd.data_emissao).to eq("20/01/2017")
          expect(npd.credor).to eq("00004600")
          expect(npd.documento_credor).to eq("07.954.605/0001-60")
          expect(npd.valor).to eq(15168.94)
          expect(npd.numero_nld_ordinaria).to eq("00011129")
          expect(npd.servico_bancario).to eq("Autenticação Bancária")
          expect(npd.banco_origem).to eq("104")
          expect(npd.agencia_origem).to eq("0919")
          expect(npd.digito_agencia_origem).to eq("9")
          expect(npd.conta_origem).to eq("0060701600")
          expect(npd.digito_conta_origem).to eq("5")
          expect(npd.banco_pagamento).to eq("104")
          expect(npd.banco_beneficiario).to eq("104")
          expect(npd.agencia_beneficiario).to eq("0919")
          expect(npd.digito_agencia_beneficiario).to eq("9")
          expect(npd.conta_beneficiario).to eq("0060000180")
          expect(npd.digito_conta_beneficiario).to eq("0")
          expect(npd.status_movimento_bancario).to eq("CONFIRMADO")
          expect(npd.data_retorno_remessa_bancaria).to eq("25/08/2017")
          expect(npd.data_atual).to eq("20/09/2017")

          expect(npd.nld.id).to eq(nld.id)

          expect(npd.management_unit).to eq(organ)
          expect(npd.executing_unit).to eq (organ)
          expect(npd.creditor).to eq(creditor)

        end
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
      expect(Integration::Expenses::Npds::CreateStats).to receive(:call).with(2017, 1)
      expect(Integration::Expenses::Npds::CreateStats).to receive(:call).with(2017, 2)
      expect(Integration::Expenses::Npds::CreateStats).to receive(:call).with(2017, 3)


      service.call
    end
  end
end
