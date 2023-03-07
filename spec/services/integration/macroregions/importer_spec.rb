require 'rails_helper'

describe Integration::Macroregions::Importer do
  let(:configuration) { create(:integration_macroregions_configuration, year: Date.current.year) }

  let(:year) { Date.current.year }
  let(:month) { Date.current.month }

  let(:service) { Integration::Macroregions::Importer.new(configuration.id) }

  let!(:power) { create(:integration_macroregions_power, name: 'JUDICIÁRIO', code: '2') }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Macroregions::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Macroregions::Importer.call(1)

      expect(Integration::Macroregions::Importer).to have_received(:new).with(1)
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
          consultar_investimentos_macroregiao_response: {
            lista_investimentos_macroregiao: {
              investimentos_macroregiao: [
                {
                  ano_exercicio: '2017',
                  codigo_poder: '2',
                  descricao_poder: 'JUDICIÁRIO',
                  codigo_regiao: '15',
                  descricao_regiao: 'ESTADO DO CEARÁ',
                  valor_lei: '14509318',
                  valor_empenhado: '12579469.76',
                  valor_pago: '7022290.67',
                  perc_empenho: '0.86',
                  perc_pago: '0.48'
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
          ano: configuration.year,
          poder: configuration.power
        }
      end

      before do
        response = double()

        allow(service.client).to receive(:call).
          with(:consultar_investimentos_macroregiao, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) { empty_body }

        it { expect(Integration::Macroregions::MacroregionInvestiment.count).to eq(0) }
      end

      describe 'create investiment' do
        it { expect(Integration::Macroregions::MacroregionInvestiment.count).to eq(1) }
      end

      describe 'associations' do
        let(:investiment) { Integration::Macroregions::MacroregionInvestiment.last }

        describe 'create region' do
          it { expect(investiment.region.code).to eq('15') }
          it { expect(investiment.region.name).to eq('ESTADO DO CEARÁ') }
          it { expect(Integration::Macroregions::Region.count).to eq(1) }
        end
      end

      describe 'create investiment' do
        let(:investiment) { Integration::Macroregions::MacroregionInvestiment.last }

        it { expect(investiment.ano_exercicio).to eq('2017') }
        it { expect(investiment.codigo_poder).to eq('2') }
        it { expect(investiment.descricao_poder).to eq('JUDICIÁRIO') }
        it { expect(investiment.codigo_regiao).to eq('15') }
        it { expect(investiment.descricao_regiao).to eq('ESTADO DO CEARÁ') }
        it { expect(investiment.valor_lei).to eq(14509318) }
        it { expect(investiment.valor_empenhado).to eq(12579469.76) }
        it { expect(investiment.valor_pago).to eq(7022290.67) }
        it { expect(investiment.perc_empenho).to eq(0.86) }
        it { expect(investiment.perc_pago).to eq(0.48) }

        it { expect(investiment.power_id).to eq(power.id) }
      end

      describe 'calls' do
        it 'call create_stats' do
          today = Date.today

          allow(Integration::Macroregions::CreateStats).to receive(:call).with(today.year, today.month)
          service.call

          expect(Integration::Macroregions::CreateStats).to have_received(:call).with(today.year, today.month)
        end

        it 'call create_spreadsheet' do
          today = Date.today

          allow(Integration::Macroregions::CreateSpreadsheet).to receive(:call).with(today.year, today.month)
          service.call

          expect(Integration::Macroregions::CreateSpreadsheet).to have_received(:call).with(today.year, today.month)
        end
      end
    end
  end
end
