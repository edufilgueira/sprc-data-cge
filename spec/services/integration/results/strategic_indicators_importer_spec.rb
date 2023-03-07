require 'rails_helper'

describe Integration::Results::StrategicIndicatorsImporter do

  let(:configuration) { create(:integration_results_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Results::StrategicIndicatorsImporter.new(configuration.id, logger) }

  let!(:organ) { create(:integration_supports_organ, sigla: 'SEPLAG', orgao_sfp: false) }
  let!(:axis) { create(:integration_supports_axis, codigo_eixo: '1') }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Results::StrategicIndicatorsImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Results::StrategicIndicatorsImporter.call(1, logger)

      expect(Integration::Results::StrategicIndicatorsImporter).to have_received(:new).with(1, logger)
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
          consulta_indicadores_estrategicos_response: {
            lista_indicadores: {
              indicador_estrategico: [
                {
                  :eixo=>{
                    :codigo_eixo=>"1",
                    :descricao_eixo=>"CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS"
                  },
                  :resultado=>"Serviços públicos estaduais planejados e geridos de forma eficiente e efetiva, atendendo as necessidades dos cidadãos, com transparência e equilíbrio fiscal",
                  :indicador=>"Investimento/Receita Corrente Líquida (%) ",
                  :unidade=>"percentual",
                  :sigla_orgao=>"SEPLAG         ",
                  :orgao=>"SECRETARIA DO PLANEJAMENTO E GESTÃO",
                  :valores_realizados=>{
                    :valor_realizado=>[{
                      :ano=>"2012", :valor=>"17"
                    },
                    {
                      :ano=>"2013", :valor=>"16.70"
                    },
                    {
                      :ano=>"2014", :valor=>"24.10"
                    }]
                  },
                  :valores_atuais=>nil
                }
              ]
            }
          }
        }
      end

      let(:message) do
        {
          usuario: configuration.user,
          senha: configuration.password
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_indicadores_estrategicos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_indicadores_estrategicos_response: { } }
        end

        it { expect(Integration::Results::StrategicIndicator.count).to eq(0) }
      end

      describe 'create strategic_indicator' do
        it { expect(Integration::Results::StrategicIndicator.count).to eq(1) }
      end

      describe 'attributes' do
        let(:strategic_indicator) { Integration::Results::StrategicIndicator.last }

        it { expect(strategic_indicator.eixo).to eq({
          'codigo_eixo'=>'1',
          'descricao_eixo'=>'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS'
        }) }

        it { expect(strategic_indicator.resultado).to eq('Serviços públicos estaduais planejados e geridos de forma eficiente e efetiva, atendendo as necessidades dos cidadãos, com transparência e equilíbrio fiscal') }
        it { expect(strategic_indicator.indicador).to eq('Investimento/Receita Corrente Líquida (%) ') }
        it { expect(strategic_indicator.unidade).to eq('percentual') }
        it { expect(strategic_indicator.sigla_orgao).to eq('SEPLAG         ') }
        it { expect(strategic_indicator.orgao).to eq('SECRETARIA DO PLANEJAMENTO E GESTÃO') }
        it { expect(strategic_indicator.valores_realizados).to eq({
          'valor_realizado'=>[{
            'ano'=>'2012', 'valor'=>'17'
          },
          {
            'ano'=>'2013', 'valor'=>'16.70'
          },
          {
            'ano'=>'2014', 'valor'=>'24.10'
          }]
        }) }

        it { expect(strategic_indicator.valores_atuais).to eq(nil) }

        it { expect(strategic_indicator.organ).to eq(organ) }
        it { expect(strategic_indicator.axis).to eq(axis) }
      end
    end
  end
end
