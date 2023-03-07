require 'rails_helper'

describe Integration::Expenses::BudgetBalanceImporter do

  let(:configuration) { create(:integration_expenses_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Expenses::BudgetBalanceImporter.new(configuration, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Expenses::BudgetBalanceImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Expenses::BudgetBalanceImporter.call(1, logger)

      expect(Integration::Expenses::BudgetBalanceImporter).to have_received(:new).with(1, logger)
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
          consulta_saldo_orcamentario_response: {
            saldo_orcamentario: [
              {
                data_atual: "16/05/2018",
                ano_mes_competencia: "07-2017",
                cod_unid_gestora: "010001",
                cod_unid_orcam: "01100001",
                cod_funcao: "01",
                cod_subfuncao: "031",
                cod_programa: "051",
                cod_acao: "22431",
                cod_localizacao_gasto: "15",
                cod_natureza_desp: "33903300",
                cod_fonte: "10000",
                id_uso: "0",
                cod_grupo_desp: "MAN",
                cod_tp_orcam: "1",
                cod_esfera_orcam: "1",
                cod_grupo_fin: "13",
                classif_orcam_reduz: "2",
                classif_orcam_completa: "01100001010310512243115339033001000002000",
                valor_inicial: "0.00",
                valor_suplementado: "0.00",
                valor_anulado: "0.00",
                valor_transferido_recebido: "0.00",
                valor_transferido_concedido: "0.00",
                valor_contido: "0.00",
                valor_contido_anulado: "0.00",
                valor_descentralizado: "0.00",
                valor_descentralizado_anulado: "0.00",
                valor_empenhado: "67342.83",
                valor_empenhado_anulado: "0.00",
                valor_liquidado: "50103.03",
                valor_liquidado_anulado: "374.21",
                valor_liquidado_retido: "50.26",
                valor_liquidado_retido_anulado: "0.00",
                valor_pago: "52846.69",
                valor_pago_anulado: "374.21"
              }
            ]
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.budget_balance_user,
          senha: configuration.budget_balance_password,
          mes: configuration.started_at.month,
          exercicio: configuration.started_at.year,
          unidade_gestora: ''
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_saldo_orcamentario, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_saldo_orcamentario_response: { } }
        end

        it { expect(Integration::Expenses::BudgetBalance.count).to eq(0) }
      end

      describe 'create budget_balance' do
        let(:budget_balance) { Integration::Expenses::BudgetBalance.last }

        it { expect(Integration::Expenses::BudgetBalance.count).to eq(1) }
      end

      describe 'create budget_balance update' do
        
        let(:body) do
          {
            consulta_saldo_orcamentario_response: {
              saldo_orcamentario: [
                {
                  data_atual: "16/05/2018",
                  ano_mes_competencia: "07-2017",
                  cod_unid_gestora: "010001",
                  cod_unid_orcam: "01100001",
                  cod_funcao: "01",
                  cod_subfuncao: "031",
                  cod_programa: "051",
                  cod_acao: "22431",
                  cod_localizacao_gasto: "15",
                  cod_natureza_desp: "33903300",
                  cod_fonte: "10000",
                  id_uso: "0",
                  cod_grupo_desp: "MAN",
                  cod_tp_orcam: "1",
                  cod_esfera_orcam: "1",
                  cod_grupo_fin: "13",
                  classif_orcam_reduz: "2",
                  classif_orcam_completa: "01100001010310512243115339033001000002000",
                  valor_inicial: "0.00",
                  valor_suplementado: "0.00",
                  valor_anulado: "0.00",
                  valor_transferido_recebido: "0.00",
                  valor_transferido_concedido: "0.00",
                  valor_contido: "0.00",
                  valor_contido_anulado: "0.00",
                  valor_descentralizado: "0.00",
                  valor_descentralizado_anulado: "0.00",
                  valor_empenhado: "67342.83",
                  valor_empenhado_anulado: "0.00",
                  valor_liquidado: "50103.03",
                  valor_liquidado_anulado: "374.21",
                  valor_liquidado_retido: "50.26",
                  valor_liquidado_retido_anulado: "0.00",
                  valor_pago: "52846.69",
                  valor_pago_anulado: "374.21"
                },
                {
                  data_atual: "16/05/2018",
                  ano_mes_competencia: "07-2017",
                  cod_unid_gestora: "010001",
                  cod_unid_orcam: "01100001",
                  cod_funcao: "01",
                  cod_subfuncao: "031",
                  cod_programa: "051",
                  cod_acao: "22431",
                  cod_localizacao_gasto: "15",
                  cod_natureza_desp: "33903300",
                  cod_fonte: "10000",
                  id_uso: "0",
                  cod_grupo_desp: "MAN",
                  cod_tp_orcam: "1",
                  cod_esfera_orcam: "1",
                  cod_grupo_fin: "10",
                  classif_orcam_reduz: "2",
                  classif_orcam_completa: "01100001010310512243115339033001000002000",
                  valor_inicial: "0.00",
                  valor_suplementado: "0.00",
                  valor_anulado: "0.00",
                  valor_transferido_recebido: "0.00",
                  valor_transferido_concedido: "0.00",
                  valor_contido: "0.00",
                  valor_contido_anulado: "0.00",
                  valor_descentralizado: "0.00",
                  valor_descentralizado_anulado: "0.00",
                  valor_empenhado: "9999.00",
                  valor_empenhado_anulado: "0.00",
                  valor_liquidado: "9999.00",
                  valor_liquidado_anulado: "9999.00",
                  valor_liquidado_retido: "9999.00",
                  valor_liquidado_retido_anulado: "0.00",
                  valor_pago: "52846.69",
                  valor_pago_anulado: "374.21"
                }
              ]
            }
          }

        end
        
        let(:budget_balance) { Integration::Expenses::BudgetBalance.last }

        it 'Budgetbalance has updated' do
          expect(Integration::Expenses::BudgetBalance.count).to eq(1)
          expect(budget_balance.valor_empenhado).to eq(9999.00)
          expect(budget_balance.valor_liquidado).to eq(9999.00)
          expect(budget_balance.valor_liquidado_anulado).to eq(9999.00)
          expect(budget_balance.valor_liquidado_retido).to eq(9999.00)
          expect(budget_balance.cod_grupo_fin).to eq("10")
        end
      end

      describe 'with items = Array' do
        describe 'create budget_balance' do
          let(:budget_balance) { Integration::Expenses::BudgetBalance.last }

          it 'imports data' do

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
      current_month = Date.today.month
      current_year = Date.today.year

      (1..current_month).each do |month_start|
        month_range = { month_start: month_start, month_end: current_month }

        expect(Integration::Expenses::BudgetBalances::CreateStats).to receive(:call).with(current_year, 0, month_range)
      end

      service.call
    end

    it 'create_spreadsheets' do
      current_month = Date.today.month
      current_year = Date.today.year

      (1..current_month).each do |month_start|
        month_range = { month_start: month_start, month_end: current_month }

        expect(Integration::Expenses::BudgetBalances::CreateSpreadsheet).to receive(:call).with(current_year, 0, month_range)
      end

      service.call

    end
  end
end
