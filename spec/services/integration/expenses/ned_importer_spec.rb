require 'rails_helper'

describe Integration::Expenses::NedImporter do

  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let!(:organ) { create(:integration_supports_management_unit, codigo: '101021') }
  let!(:creditor) { create(:integration_supports_creditor, codigo: '00822309') }

  let!(:npf) { create(:integration_expenses_npf, unidade_gestora: '101021', numero: '00011129') }

  let(:service) { Integration::Expenses::NedImporter.new(configuration, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::NedImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Expenses::NedImporter.call(1, logger)

      expect(Integration::Expenses::NedImporter).to have_received(:new).with(1, logger)
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
          consulta_nota_empenho_despesa_response: {
            nota_empenho_despesa: [
              {
                exercicio: "2017",
                unidade_gestora: "101021",
                unidade_executora: "101021",
                numero: "00011129",
                natureza: "Ordinária",
                efeito: "DESEMBOLSO",
                data_emissao: "25/08/2017",
                valor: "7058.06",
                valor_pago: "7058.06",
                classificacao_orcamentaria_reduzido: "1478",
                classificacao_orcamentaria_completo: "10100002061220032238703339014001000003000",
                item_despesa: "33901400001",
                cpf_ordenador_despesa: "26022680387",
                credor: "00822309",
                cpf_cnpj_credor: "08042231733",
                razao_social_credor: "PAULO RENATO FELIX FERREIRA",
                numero_npf_ordinario: "00011129",
                projeto: "1010210022016C",
                numero_parcela: "861",
                isn_parcela: "1454260",
                numero_proposta: "11322",
                numero_processo_protocolo_original: "58161232017",
                especificacao_geral: "VALOR REFERENTE AO PAGAMENTO DE DIÁRIAS DENTRO DO ESTADO, CONFORME PORTARIA 377/2017-DIFIN.",
                data_atual: "18/09/2017",
                lista_itens_ned: {
                  item_ned: ned_items
                },
                lista_itens_planejamento_empenho: {
                  item_planejamento_empenho: ned_planning_items
                },
                lista_previsoes_desembolso: {
                  previsao_desembolso: ned_disbursement_forecasts
                }
              },

              {
                exercicio: "2017",
                unidade_gestora: "101022",
                unidade_executora: "101022",
                numero: "00011130",
                natureza: "Ordinária",
                efeito: "DESEMBOLSO",
                data_emissao: "26/08/2017",
                valor: "17058.06",
                valor_pago: "17058.06",
                classificacao_orcamentaria_reduzido: "1478",
                classificacao_orcamentaria_completo: "10100002061220032238703339014001000003000",
                item_despesa: "33901400001",
                cpf_ordenador_despesa: "26022680387",
                credor: "00822309",
                cpf_cnpj_credor: "08042231733",
                razao_social_credor: "PAULO RENATO FELIX FERREIRA",
                numero_npf_ordinario: "00011129",
                projeto: "1010210022016C",
                numero_parcela: "861",
                isn_parcela: "1454260",
                numero_proposta: "11322",
                numero_processo_protocolo_original: "58161232017",
                especificacao_geral: "VALOR REFERENTE AO PAGAMENTO DE DIÁRIAS DENTRO DO ESTADO, CONFORME PORTARIA 377/2017-DIFIN.",
                data_atual: "18/09/2017",
                lista_itens_ned: {
                  item_ned: []
                },
                lista_itens_planejamento_empenho: {
                  item_planejamento_empenho: []
                },
                lista_previsoes_desembolso: {
                  previsao_desembolso: []
                }
              }
            ]
          }
        }
      end

      let(:ned_items) do
        {
          sequencial: "1",
          especificacao: "DIÁRIAS",
          unidade: "UN",
          quantidade: "1.00",
          valor_unitario: "7058.06"
        }
      end

      let(:ned_planning_items) do
        {
          isn_item_parcela: "1603059",
          valor: "7058.06"
        }
      end

      let(:ned_disbursement_forecasts) do
        {
          data: "25/08/2017",
          valor: "7058.06"
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
          with(:consulta_nota_empenho_despesa, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_nota_empenho_despesa_response: { } }
        end

        it { expect(Integration::Expenses::Ned.count).to eq(0) }
      end

      describe 'create ned' do
        let(:ned) { Integration::Expenses::Ned.last }

        it { expect(Integration::Expenses::Ned.count).to eq(2) }
      end

      describe 'with items = Array' do
        describe 'create ned' do
          let(:ned) { Integration::Expenses::Ned.first }

          let(:last_ned) { Integration::Expenses::Ned.last }

          it 'imports data' do
            expect(ned.exercicio).to eq(2017)
            expect(ned.unidade_gestora).to eq("101021")
            expect(ned.unidade_executora).to eq("101021")
            expect(ned.numero).to eq("00011129")
            expect(ned.natureza).to eq("Ordinária")
            expect(ned.efeito).to eq("DESEMBOLSO")
            expect(ned.data_emissao).to eq("25/08/2017")
            expect(ned.valor).to eq(7058.06)
            expect(ned.valor_pago).to eq(7058.06)
            expect(ned.classificacao_orcamentaria_reduzido).to eq(1478)
            expect(ned.classificacao_orcamentaria_completo).to eq("10100002061220032238703339014001000003000")
            expect(ned.item_despesa).to eq("33901400001")
            expect(ned.cpf_ordenador_despesa).to eq("26022680387")
            expect(ned.credor).to eq("00822309")
            expect(ned.cpf_cnpj_credor).to eq("08042231733")
            expect(ned.razao_social_credor).to eq("PAULO RENATO FELIX FERREIRA")
            expect(ned.numero_npf_ordinario).to eq("00011129")
            expect(ned.projeto).to eq("1010210022016C")
            expect(ned.numero_parcela).to eq("861")
            expect(ned.isn_parcela).to eq(1454260)
            expect(ned.numero_proposta).to eq(11322)
            expect(ned.numero_processo_protocolo_original).to eq("58161232017")
            expect(ned.especificacao_geral).to eq("VALOR REFERENTE AO PAGAMENTO DE DIÁRIAS DENTRO DO ESTADO, CONFORME PORTARIA 377/2017-DIFIN.")
            expect(ned.data_atual).to eq("18/09/2017")

            expect(ned.npf_ordinaria).to eq(npf)

            expect(ned.management_unit).to eq(organ)
            expect(ned.executing_unit).to eq (organ)
            expect(ned.creditor).to eq (creditor)


            expect(last_ned.data_emissao).to eq("26/08/2017")
          end

          describe 'items' do
            let(:ned_item) { ned.ned_items.first }

            it 'imports single item' do
              expect(ned_item.sequencial).to eq(1)
              expect(ned_item.especificacao).to eq("DIÁRIAS")
              expect(ned_item.unidade).to eq("UN")
              expect(ned_item.quantidade).to eq(1.00)
              expect(ned_item.valor_unitario).to eq(7058.06)
            end

            describe 'multiple items' do
              let(:ned_item) { ned.ned_items.last }

              let(:ned_items) do
                [
                  {
                    sequencial: "1",
                    especificacao: "DIÁRIAS",
                    unidade: "UN",
                    quantidade: "1.00",
                    valor_unitario: "7058.06"
                  },
                  {
                    sequencial: "2",
                    especificacao: "DIÁRIAS 2",
                    unidade: "UN",
                    quantidade: "2.00",
                    valor_unitario: "8058.06"
                  }
                ]
              end

              it 'imports multiple items' do
                expect(ned_item.sequencial).to eq(2)
                expect(ned_item.especificacao).to eq("DIÁRIAS 2")
                expect(ned_item.unidade).to eq("UN")
                expect(ned_item.quantidade).to eq(2.00)
                expect(ned_item.valor_unitario).to eq(8058.06)
              end
            end
          end

          describe 'planning_items' do
            let(:ned_planning_item) { ned.ned_planning_items.first }

            describe 'single item' do

              it { expect(ned_planning_item.isn_item_parcela).to eq(1603059) }
              it { expect(ned_planning_item.valor).to eq(7058.06) }
            end

            describe 'multiple planning_items' do
              let(:ned_planning_item) { ned.ned_planning_items.last }
              let(:ned_planning_items) do
                [
                  {
                    isn_item_parcela: "1603059",
                    valor: "7058.06"
                  },
                  {
                    isn_item_parcela: "1603060",
                    valor: "8058.06"
                  }
                ]
              end

              it { expect(ned_planning_item.isn_item_parcela).to eq(1603060) }
              it { expect(ned_planning_item.valor).to eq(8058.06) }
            end
          end

          describe 'disbursement_forecasts' do
            let(:ned_disbursement_forecast) { ned.ned_disbursement_forecasts.first }

            describe 'single item' do

              it { expect(ned_disbursement_forecast.data).to eq("25/08/2017") }
              it { expect(ned_disbursement_forecast.valor).to eq(7058.06) }
            end

            describe 'multiple disbursement_forecasts' do
              let(:ned_disbursement_forecast) { ned.ned_disbursement_forecasts.last }
              let(:ned_disbursement_forecasts) do
                [
                  {
                    data: "25/08/2017",
                    valor: "7058.06"
                  },
                  {
                    data: "25/08/2016",
                    valor: "8058.06"
                  }
                ]
              end

              it { expect(ned_disbursement_forecast.data).to eq("25/08/2016") }
              it { expect(ned_disbursement_forecast.valor).to eq(8058.06) }
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
      expect(Integration::Expenses::Neds::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::CityTransfers::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::ProfitTransfers::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::NonProfitTransfers::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::MultiGovTransfers::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::ConsortiumTransfers::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::FundSupplies::CreateStats).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::Dailies::CreateStats).to receive(:call).with(2017, 0)

      service.call
    end
  end

  describe 'spreadsheets' do
    let(:body) { {} }

    let(:configuration) { create(:integration_expenses_configuration, started_at: '01/01/2017', finished_at: '03/03/2017' ) }

    before do
      response = double()
      allow(service.client).to receive(:call).with(any_args).and_return(response)
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'create_spreadsheets' do
      expect(Integration::Expenses::Neds::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::CityTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::ProfitTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::NonProfitTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::MultiGovTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::ConsortiumTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::FundSupplies::CreateSpreadsheet).to receive(:call).with(2017, 0)
      expect(Integration::Expenses::Dailies::CreateSpreadsheet).to receive(:call).with(2017, 0)

      service.call
    end
  end
end
