require 'rails_helper'

describe Integration::Expenses::NldImporter do
  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let!(:organ) { create(:integration_supports_management_unit, codigo: '101021') }
  let!(:creditor) { create(:integration_supports_creditor, codigo: '00077485') }

  let!(:ned) { create(:integration_expenses_ned, unidade_gestora: '101021', numero: '00011129') }

  let(:service) { Integration::Expenses::NldImporter.new(configuration, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::NldImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Expenses::NldImporter.call(1, logger)

      expect(Integration::Expenses::NldImporter).to have_received(:new).with(1, logger)
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
          consulta_nota_liquidacao_despesa_response: {
            nota_liquidacao_despesa: [
              {
                exercicio: "2017",
                unidade_gestora: "101021",
                unidade_executora: "101021",
                numero: "00011129",
                natureza: "ORDINARIA",
                tipo_de_documento_da_despesa: "Outros",
                numero_do_documento_da_despesa: "58749722017",
                data_do_documento_da_despesa: "24/08/2017",
                efeito: "DESEMBOLSO",
                processo_administrativo_despesa: "89364",
                data_emissao: "25/08/2017",
                valor: "5961.30",
                valor_retido: "0.00",
                cpf_ordenador_despesa: "07275760894",
                credor: "00077485",
                numero_nota_empenho_despesa: "00011129",
                exercicio_restos_a_pagar: ned.exercicio,
                lista_item_retencao_pagamento: {
                  item_retencao_pagamento: nld_item_payment_retentions
                },
                lista_item_planejamento_pagamento: {
                  item_planejamento_pagamento: nld_item_payment_plannings
                },
                data_atual: "20/09/2017"
              }
            ]
          }
        }
      end

      let(:nld_item_payment_plannings) do
        {
          codigo_isn: "1605490",
          valor_liquidado: "5961.30"
        }
      end

      let(:nld_item_payment_retentions) do
        {
          codigo_retencao: "1111",
          credor: "BLA",
          valor: "30.45"
        }
      end

      let(:message) do
        {
          usuario: configuration.nld_user,
          senha: configuration.nld_password,
          data_inicio: configuration.started_at.to_s,
          data_fim: configuration.finished_at.to_s
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_nota_liquidacao_despesa, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_nota_liquidacao_despesa_response: { } }
        end

        it { expect(Integration::Expenses::Nld.count).to eq(0) }
      end

      describe 'create nld' do
        let(:nld) { Integration::Expenses::Nld.last }

        it { expect(Integration::Expenses::Nld.count).to eq(1) }
      end

      describe 'with items = Array' do
        let(:nld) { Integration::Expenses::Nld.last }

        it 'imports data' do
          expect(nld.exercicio).to eq(2017)
          expect(nld.unidade_gestora).to eq("101021")
          expect(nld.unidade_executora).to eq("101021")
          expect(nld.numero).to eq("00011129")
          expect(nld.natureza).to eq("ORDINARIA")
          expect(nld.tipo_de_documento_da_despesa).to eq("Outros")
          expect(nld.numero_do_documento_da_despesa).to eq("58749722017")
          expect(nld.data_do_documento_da_despesa).to eq("24/08/2017")
          expect(nld.efeito).to eq("DESEMBOLSO")
          expect(nld.processo_administrativo_despesa).to eq("89364")
          expect(nld.data_emissao).to eq("25/08/2017")
          expect(nld.valor).to eq(5961.30)
          expect(nld.valor_retido).to eq(0.00)
          expect(nld.cpf_ordenador_despesa).to eq("07275760894")
          expect(nld.credor).to eq("00077485")
          expect(nld.numero_nota_empenho_despesa).to eq("00011129")
          expect(nld.exercicio_restos_a_pagar).to eq(ned.exercicio.to_s)

          expect(nld.ned.id).to eq(ned.id)

          expect(nld.management_unit).to eq(organ)
          expect(nld.executing_unit).to eq(organ)
          expect(nld.creditor).to eq(creditor)
        end

        describe 'planning items' do
          let(:nld_planning_item) { nld.nld_item_payment_plannings.first }

          it 'imports single item' do
            expect(nld_planning_item.codigo_isn).to eq(1605490)
            expect(nld_planning_item.valor_liquidado).to eq(5961.30)
          end

          describe 'multiple items' do
            let(:nld_planning_item) { nld.nld_item_payment_plannings.last }
            let(:nld_item_payment_plannings) do
              [
                {
                  codigo_isn: "1605490",
                  valor_liquidado: "5961.30"
                },
                {
                  codigo_isn: "05490",
                  valor_liquidado: "61.30"
                }
              ]
            end

            it 'imports data' do
              expect(nld_planning_item.codigo_isn).to eq(5490)
              expect(nld_planning_item.valor_liquidado).to eq(61.30)
            end
          end

          describe 'retention items' do
            let(:nld_retention_item) { nld.nld_item_payment_retentions.first }

            it 'imports single item' do
              expect(nld_retention_item.codigo_retencao).to eq("1111")
              expect(nld_retention_item.credor).to eq("BLA")
              expect(nld_retention_item.valor).to eq(30.45)
            end

            describe 'multiple items' do
              let(:nld_retention_item) { nld.nld_item_payment_retentions.last }
              let(:nld_item_payment_retentions) do
                [
                  {
                    codigo_retencao: "1111",
                    credor: "BLA",
                    valor: "30.45"
                  },
                  {
                    codigo_retencao: "2222",
                    credor: "ALB",
                    valor: "45.30"
                  }
                ]
              end

              it 'imports data' do
                expect(nld_retention_item.codigo_retencao).to eq("2222")
                expect(nld_retention_item.credor).to eq("ALB")
                expect(nld_retention_item.valor).to eq(45.30)
              end
            end

          end
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
      expect(Integration::Expenses::Nlds::CreateStats).to receive(:call).with(2017, 1)
      expect(Integration::Expenses::Nlds::CreateStats).to receive(:call).with(2017, 2)
      expect(Integration::Expenses::Nlds::CreateStats).to receive(:call).with(2017, 3)


      service.call
    end
  end
end
