require 'rails_helper'

describe Integration::Revenues::Importer do

  let!(:organ) { create(:integration_supports_organ, codigo_orgao: '040101', orgao_sfp: false) }

  let(:account_configuration) do
    create(:integration_revenues_account_configuration)
  end
  let(:configuration) do
    account_configuration.configuration
  end

  let(:service) { Integration::Revenues::Importer.new(configuration.id) }

  let(:year) { configuration.month.split('/')[1].to_i }
  let(:month) { 0 }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Revenues::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Revenues::Importer.call(1)

      expect(Integration::Revenues::Importer).to have_received(:new).with(1)
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
          consulta_saldo_contas_contabeis_response: {
            conta: [
              {
                unidade: "040101",
                poder: "EXECUTIVO",
                administracao: "INDIRETA",
                conta_contabil: "6.2.1.3",
                titulo: "(-) Deduções da Receita Orçamentária ",
                natureza_da_conta: "DÉBITO",
                natureza_credito: "DEBITO",
                valor_credito: "0.00",
                natureza_debito: "CRÉDITO",
                valor_debito: "14167.30",
                valor_inicial: "0",
                natureza_inicial: nil,
                fechamento_contabil: "4",
                data_atual: "06/06/2017",
                contas_correntes: {
                  conta: accounts
                }
              }
            ]
          }
        }
      end

      let(:accounts) do
        {
          conta_corrente: "911220800.27000",
          natureza_credito: "DEBITO",
          valor_credito: "0.00",
          natureza_debito: "CRÉDITO",
          valor_debito: "14167.30",
          valor_inicial: "0",
          natureza_inicial: nil,
          mes: "2"
        }
      end

      let(:message) do
        {
          usuario: configuration.user,
          senha: configuration.password,
          filtro: {
            mes: Date.parse(configuration.month).month,
            exercicio: Date.parse(configuration.month).year,
            conta: account_configuration.account_number
          }
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_saldo_contas_contabeis, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end


      describe 'statuses' do
        it { expect(configuration.status_success?).to be_truthy }

        describe 'error' do
          before do
            allow(service).to receive(:revenues_for_account) { raise 'Error' }
            service.call
            configuration.reload
          end

          it { expect(configuration.status_fail?).to be_truthy }

        end
      end

      describe 'with contas = nil' do
        let(:body) do
          { consulta_saldo_contas_contabeis_response: { } }
        end

        it { expect(Integration::Revenues::Revenue.count).to eq(0) }
      end

      describe 'with contas = Hash' do
        let(:body) do
          {
            consulta_saldo_contas_contabeis_response: {
              conta: {
                unidade: "040101",
                poder: "EXECUTIVO",
                administracao: "INDIRETA",
                conta_contabil: "6.2.1.3",
                titulo: "(-) Deduções da Receita Orçamentária ",
                natureza_da_conta: "DÉBITO",
                natureza_credito: "DEBITO",
                valor_credito: "0.00",
                natureza_debito: "CRÉDITO",
                valor_debito: "14167.30",
                valor_inicial: "0",
                natureza_inicial: nil,
                fechamento_contabil: "4",
                data_atual: "06/06/2017",
                contas_correntes: {
                  conta: accounts
                }
              }
            }
          }
        end
        describe 'create revenue' do
          let(:revenue) { Integration::Revenues::Revenue.last }

          it { expect(Integration::Revenues::Revenue.count).to eq(1) }
        end
      end

      describe 'with contas = Array' do
        describe 'create revenue' do
          let(:revenue) { Integration::Revenues::Revenue.last }

          it 'imports data' do
            expect(revenue.unidade).to eq("040101")
            expect(revenue.poder).to eq("EXECUTIVO")
            expect(revenue.administracao).to eq("INDIRETA")
            expect(revenue.conta_contabil).to eq("6.2.1.3")
            expect(revenue.titulo).to eq("(-) Deduções da Receita Orçamentária ")
            expect(revenue.natureza_da_conta).to eq("DÉBITO")
            expect(revenue.natureza_credito).to eq("DEBITO")
            expect(revenue.valor_credito).to eq(0.00)
            expect(revenue.natureza_debito).to eq("CRÉDITO")
            expect(revenue.valor_debito).to eq(14167.30)
            expect(revenue.valor_inicial).to eq(0)
            expect(revenue.natureza_inicial).to eq(nil)
            expect(revenue.fechamento_contabil).to eq("4")
            expect(revenue.data_atual).to eq("06/06/2017")
            expect(revenue.account_configuration).to eq(account_configuration)
            expect(revenue.month).to eq(Date.parse(configuration.month).month)
            expect(revenue.year).to eq(Date.parse(configuration.month).year)

            expect(revenue.organ).to eq(organ)
          end

          describe 'JUDICIÁRIO' do
            let(:body) do
              {
                consulta_saldo_contas_contabeis_response: {
                  conta: {
                    unidade: "040101",
                    poder: "JUDICIÁRIO",
                    administracao: "INDIRETA",
                    conta_contabil: "6.2.1.3",
                    titulo: "(-) Deduções da Receita Orçamentária ",
                    natureza_da_conta: "DÉBITO",
                    natureza_credito: "DEBITO",
                    valor_credito: "0.00",
                    natureza_debito: "CRÉDITO",
                    valor_debito: "14167.30",
                    valor_inicial: "0",
                    natureza_inicial: nil,
                    fechamento_contabil: "4",
                    data_atual: "06/06/2017",
                    contas_correntes: {
                      conta: accounts
                    }
                  }
                }
              }
            end

            it 'does not import data' do
              expect(revenue).to be_nil
            end
          end

          describe 'LEGISLATIVO' do
            let(:body) do
              {
                consulta_saldo_contas_contabeis_response: {
                  conta: {
                    unidade: "040101",
                    poder: "LEGISLATIVO",
                    administracao: "INDIRETA",
                    conta_contabil: "6.2.1.3",
                    titulo: "(-) Deduções da Receita Orçamentária ",
                    natureza_da_conta: "DÉBITO",
                    natureza_credito: "DEBITO",
                    valor_credito: "0.00",
                    natureza_debito: "CRÉDITO",
                    valor_debito: "14167.30",
                    valor_inicial: "0",
                    natureza_inicial: nil,
                    fechamento_contabil: "4",
                    data_atual: "06/06/2017",
                    contas_correntes: {
                      conta: accounts
                    }
                  }
                }
              }
            end

            it 'does not import data' do
              expect(revenue).to be_nil
            end
          end

          describe 'accounts' do
            let(:account) { revenue.accounts.first }
            let(:last_account) { revenue.accounts.last }

            let(:accounts) do
              [
                {
                  conta_corrente: "911220800.27000",
                  natureza_credito: "DEBITO",
                  valor_credito: "0.00",
                  natureza_debito: "CRÉDITO",
                  valor_debito: "14167.30",
                  valor_inicial: "0",
                  natureza_inicial: nil,
                  mes: "2"
                },
                {
                  conta_corrente: "1",
                  natureza_credito: "DEBITO",
                  valor_credito: "0.00",
                  natureza_debito: "CRÉDITO",
                  valor_debito: "100.0",
                  valor_inicial: "0",
                  natureza_inicial: nil,
                  mes: "2"
                }
              ]
            end

            it 'imports accounts' do
              expect(account.conta_corrente).to eq("911220800.27000")
              expect(account.natureza_credito).to eq("DEBITO")
              expect(account.valor_credito).to eq(0.00)
              expect(account.natureza_debito).to eq("CRÉDITO")
              expect(account.valor_debito).to eq(14167.30)
              expect(account.valor_inicial).to eq(0)
              expect(account.natureza_inicial).to eq(nil)
              expect(account.mes).to eq("2")

              expect(last_account.conta_corrente).to eq("1")
              expect(last_account.natureza_credito).to eq("DEBITO")
              expect(last_account.valor_credito).to eq(0.00)
              expect(last_account.natureza_debito).to eq("CRÉDITO")
              expect(last_account.valor_debito).to eq(100.0)
              expect(last_account.valor_inicial).to eq(0)
              expect(last_account.natureza_inicial).to eq(nil)
              expect(last_account.mes).to eq("2")
            end
          end
        end
      end
    end


    describe 'stats' do
      let(:body) { {} }

      before do
        response = double()
        allow(service.client).to receive(:call).with(any_args).and_return(response)
        allow(response).to receive(:body) { body }
        service.send(:start)
      end


      it 'create_stats' do
        current_month = configuration.month.to_date.month

        (1..current_month).each do |month_start|
          month_range = { month_start: month_start, month_end: current_month }

          expect(Integration::Revenues::Accounts::CreateStats).to receive(:call).with(year, 0, month_range)
        end

        expect(Integration::Revenues::Transfers::CreateStats).to receive(:call).with(year, 0)
        expect(Integration::Revenues::RegisteredRevenues::CreateStats).to receive(:call).with(year, 0)

        service.call
      end
    end

    describe 'spreadsheet' do
      let(:body) { {} }

      before do
        response = double()
        allow(service.client).to receive(:call).with(any_args).and_return(response)
        allow(response).to receive(:body) { body }
        service.send(:start)
      end

      it 'create_spreadsheet' do
        current_month = configuration.month.to_date.month

        (1..current_month).each do |month_start|
          month_range = { month_start: month_start, month_end: current_month }

          expect(Integration::Revenues::Accounts::CreateSpreadsheet).to receive(:call).with(year, 0, month_range)
        end

        expect(Integration::Revenues::Transfers::CreateSpreadsheet).to receive(:call).with(year, 0)
        expect(Integration::Revenues::RegisteredRevenues::CreateSpreadsheet).to receive(:call).with(year, 0)

        service.call
      end
    end

  end
end
