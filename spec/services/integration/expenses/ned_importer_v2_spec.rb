require 'rails_helper'

describe Integration::Expenses::NedImporterV2 do

  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let!(:organ) { create(:integration_supports_management_unit, codigo: '101021') }
  let!(:creditor) { create(:integration_supports_creditor, codigo: '00822309') }

  let!(:npf) { create(:integration_expenses_npf, unidade_gestora: '101021', numero: '00011129') }

  let(:service) { Integration::Expenses::NedImporterV2.new(configuration.id) }

  before do
    configuration
  end

  describe 'self.call' do
    
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::NedImporterV2).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Expenses::NedImporterV2.call(1)

      expect(Integration::Expenses::NedImporterV2).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to configuration' do
      expect(service.configuration).to eq(configuration)
    end
  end

  describe 'call' do
    describe 'import' do

      before do
        etl
        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:etl) { }
        it { expect(Integration::Expenses::Ned.count).to eq(0) }
      end

      describe 'create ned' do
        let(:etl) { create(:etl_integration_expenses_ned) }

        fit { expect(Integration::Expenses::Ned.count).to eq(1) }
      end
    end
  end

  #     describe 'with items = Array' do
  #       describe 'create ned' do
  #         let(:ned) { Integration::Expenses::Ned.first }

  #         let(:last_ned) { Integration::Expenses::Ned.last }

  #         it 'imports data' do
  #           expect(ned.exercicio).to eq(2017)
  #           expect(ned.unidade_gestora).to eq("101021")
  #           expect(ned.unidade_executora).to eq("101021")
  #           expect(ned.numero).to eq("00011129")
  #           expect(ned.natureza).to eq("Ordinária")
  #           expect(ned.efeito).to eq("DESEMBOLSO")
  #           expect(ned.data_emissao).to eq("25/08/2017")
  #           expect(ned.valor).to eq(7058.06)
  #           expect(ned.valor_pago).to eq(7058.06)
  #           expect(ned.classificacao_orcamentaria_reduzido).to eq(1478)
  #           expect(ned.classificacao_orcamentaria_completo).to eq("10100002061220032238703339014001000003000")
  #           expect(ned.item_despesa).to eq("33901400001")
  #           expect(ned.cpf_ordenador_despesa).to eq("26022680387")
  #           expect(ned.credor).to eq("00822309")
  #           expect(ned.cpf_cnpj_credor).to eq("08042231733")
  #           expect(ned.razao_social_credor).to eq("PAULO RENATO FELIX FERREIRA")
  #           expect(ned.numero_npf_ordinario).to eq("00011129")
  #           expect(ned.projeto).to eq("1010210022016C")
  #           expect(ned.numero_parcela).to eq("861")
  #           expect(ned.isn_parcela).to eq(1454260)
  #           expect(ned.numero_proposta).to eq(11322)
  #           expect(ned.numero_processo_protocolo_original).to eq("58161232017")
  #           expect(ned.especificacao_geral).to eq("VALOR REFERENTE AO PAGAMENTO DE DIÁRIAS DENTRO DO ESTADO, CONFORME PORTARIA 377/2017-DIFIN.")
  #           expect(ned.data_atual).to eq("18/09/2017")

  #           expect(ned.npf_ordinaria).to eq(npf)

  #           expect(ned.management_unit).to eq(organ)
  #           expect(ned.executing_unit).to eq (organ)
  #           expect(ned.creditor).to eq (creditor)


  #           expect(last_ned.data_emissao).to eq("26/08/2017")
  #         end

  #         describe 'items' do
  #           let(:ned_item) { ned.ned_items.first }

  #           it 'imports single item' do
  #             expect(ned_item.sequencial).to eq(1)
  #             expect(ned_item.especificacao).to eq("DIÁRIAS")
  #             expect(ned_item.unidade).to eq("UN")
  #             expect(ned_item.quantidade).to eq(1.00)
  #             expect(ned_item.valor_unitario).to eq(7058.06)
  #           end

  #           describe 'multiple items' do
  #             let(:ned_item) { ned.ned_items.last }

  #             let(:ned_items) do
  #               [
  #                 {
  #                   sequencial: "1",
  #                   especificacao: "DIÁRIAS",
  #                   unidade: "UN",
  #                   quantidade: "1.00",
  #                   valor_unitario: "7058.06"
  #                 },
  #                 {
  #                   sequencial: "2",
  #                   especificacao: "DIÁRIAS 2",
  #                   unidade: "UN",
  #                   quantidade: "2.00",
  #                   valor_unitario: "8058.06"
  #                 }
  #               ]
  #             end

  #             it 'imports multiple items' do
  #               expect(ned_item.sequencial).to eq(2)
  #               expect(ned_item.especificacao).to eq("DIÁRIAS 2")
  #               expect(ned_item.unidade).to eq("UN")
  #               expect(ned_item.quantidade).to eq(2.00)
  #               expect(ned_item.valor_unitario).to eq(8058.06)
  #             end
  #           end
  #         end

  #         describe 'planning_items' do
  #           let(:ned_planning_item) { ned.ned_planning_items.first }

  #           describe 'single item' do

  #             it { expect(ned_planning_item.isn_item_parcela).to eq(1603059) }
  #             it { expect(ned_planning_item.valor).to eq(7058.06) }
  #           end

  #           describe 'multiple planning_items' do
  #             let(:ned_planning_item) { ned.ned_planning_items.last }
  #             let(:ned_planning_items) do
  #               [
  #                 {
  #                   isn_item_parcela: "1603059",
  #                   valor: "7058.06"
  #                 },
  #                 {
  #                   isn_item_parcela: "1603060",
  #                   valor: "8058.06"
  #                 }
  #               ]
  #             end

  #             it { expect(ned_planning_item.isn_item_parcela).to eq(1603060) }
  #             it { expect(ned_planning_item.valor).to eq(8058.06) }
  #           end
  #         end

  #         describe 'disbursement_forecasts' do
  #           let(:ned_disbursement_forecast) { ned.ned_disbursement_forecasts.first }

  #           describe 'single item' do

  #             it { expect(ned_disbursement_forecast.data).to eq("25/08/2017") }
  #             it { expect(ned_disbursement_forecast.valor).to eq(7058.06) }
  #           end

  #           describe 'multiple disbursement_forecasts' do
  #             let(:ned_disbursement_forecast) { ned.ned_disbursement_forecasts.last }
  #             let(:ned_disbursement_forecasts) do
  #               [
  #                 {
  #                   data: "25/08/2017",
  #                   valor: "7058.06"
  #                 },
  #                 {
  #                   data: "25/08/2016",
  #                   valor: "8058.06"
  #                 }
  #               ]
  #             end

  #             it { expect(ned_disbursement_forecast.data).to eq("25/08/2016") }
  #             it { expect(ned_disbursement_forecast.valor).to eq(8058.06) }
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  # describe 'stats' do
  #   let(:body) { {} }

  #   let(:configuration) { create(:integration_expenses_configuration, started_at: '01/01/2017', finished_at: '03/03/2017' ) }

  #   before do
  #     response = double()
  #     allow(service.client).to receive(:call).with(any_args).and_return(response)
  #     allow(response).to receive(:body) { body }
  #     service.send(:start)
  #   end

  #   it 'create_stats' do
  #     expect(Integration::Expenses::Neds::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::CityTransfers::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::ProfitTransfers::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::NonProfitTransfers::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::MultiGovTransfers::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::ConsortiumTransfers::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::FundSupplies::CreateStats).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::Dailies::CreateStats).to receive(:call).with(2017, 0)

  #     service.call
  #   end
  # end

  # describe 'spreadsheets' do
  #   let(:body) { {} }

  #   let(:configuration) { create(:integration_expenses_configuration, started_at: '01/01/2017', finished_at: '03/03/2017' ) }

  #   before do
  #     response = double()
  #     allow(service.client).to receive(:call).with(any_args).and_return(response)
  #     allow(response).to receive(:body) { body }
  #     service.send(:start)
  #   end

  #   it 'create_spreadsheets' do
  #     expect(Integration::Expenses::Neds::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::CityTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::ProfitTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::NonProfitTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::MultiGovTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::ConsortiumTransfers::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::FundSupplies::CreateSpreadsheet).to receive(:call).with(2017, 0)
  #     expect(Integration::Expenses::Dailies::CreateSpreadsheet).to receive(:call).with(2017, 0)

  #     service.call
  #   end
  # end
end
