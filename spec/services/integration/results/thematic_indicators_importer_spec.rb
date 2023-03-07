require 'rails_helper'

describe Integration::Results::ThematicIndicatorsImporter do

  let(:configuration) { create(:integration_results_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Results::ThematicIndicatorsImporter.new(configuration.id, logger) }

  let!(:organ) { create(:integration_supports_organ, sigla: 'SEFAZ', orgao_sfp: false) }
  let!(:axis) { create(:integration_supports_axis, codigo_eixo: '1') }
  let!(:theme) { create(:integration_supports_theme, codigo_tema: '1.01') }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Results::ThematicIndicatorsImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Results::ThematicIndicatorsImporter.call(1, logger)

      expect(Integration::Results::ThematicIndicatorsImporter).to have_received(:new).with(1, logger)
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
          consulta_indicadores_tematicos_response: {
            lista_indicadores: {
              indicador_tematico: [
                {
                  :eixo=>{
                    :codigo_eixo=>"1",
                    :descricao_eixo=>"CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS"
                  },
                  :tema=>{
                    :codigo_tema=>"1.01",
                    :descricao_tema=>"GESTÃO FISCAL"
                  },
                  :resultado=>"Equilíbrio Fiscal e Orçamentário garantido",
                  :indicador=>"Capacidade de investimento do Tesouro",
                  :unidade=>"R$ milhão",
                  :sigla_orgao=>"SEFAZ",
                  :orgao=>"SECRETARIA DA FAZENDA",
                  :valores_realizados=>{
                    :valor_realizado=>[
                      {:ano=>"2012", :valor=>"1857.10"},
                      {:ano=>"2013", :valor=>"1191.73"},
                      {:ano=>"2014", :valor=>"622.19"},
                      {:ano=>"2015", :valor=>"629.36"},
                      {:ano=>"2016", :valor=>"1634.60"}
                    ]
                  },
                  :valores_programados=>{
                    :valor_programado=>[
                      {:ano=>"2016", :valor=>"547.50"},
                      {:ano=>"2017", :valor=>"621.60"},
                      {:ano=>"2018", :valor=>"860.10"},
                      {:ano=>"2019", :valor=>"715.20"}
                    ]
                  }
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
          with(:consulta_indicadores_tematicos, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_indicadores_tematicos_response: { } }
        end

        it { expect(Integration::Results::ThematicIndicator.count).to eq(0) }
      end

      describe 'create thematic_indicator' do
        it { expect(Integration::Results::ThematicIndicator.count).to eq(1) }
      end

      describe 'attributes' do
        let(:thematic_indicator) { Integration::Results::ThematicIndicator.last }

        it { expect(thematic_indicator.eixo).to eq({
          'codigo_eixo'=>'1',
          'descricao_eixo'=>'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS'
        }) }

        it { expect(thematic_indicator.tema).to eq({
          'codigo_tema'=>'1.01',
          'descricao_tema'=>'GESTÃO FISCAL'
        }) }

        it { expect(thematic_indicator.resultado).to eq('Equilíbrio Fiscal e Orçamentário garantido') }
        it { expect(thematic_indicator.indicador).to eq('Capacidade de investimento do Tesouro') }
        it { expect(thematic_indicator.unidade).to eq('R$ milhão') }
        it { expect(thematic_indicator.sigla_orgao).to eq('SEFAZ') }
        it { expect(thematic_indicator.orgao).to eq('SECRETARIA DA FAZENDA') }
        it { expect(thematic_indicator.valores_realizados).to eq({
          'valor_realizado'=>[{
            'ano'=>'2012', 'valor'=>'1857.10'
          },
          {
            'ano'=>'2013', 'valor'=>'1191.73'
          },
          {
            'ano'=>'2014', 'valor'=>'622.19'
          },
          {
            'ano'=>'2015', 'valor'=>'629.36'
          },
          {
            'ano'=>'2016', 'valor'=>'1634.60'
          }]
        }) }

        it { expect(thematic_indicator.valores_programados).to eq({
          'valor_programado'=>[{
            'ano'=>'2016', 'valor'=>'547.50'
          },
          {
            'ano'=>'2017', 'valor'=>'621.60'
          },
          {
            'ano'=>'2018', 'valor'=>'860.10'
          },
          {
            'ano'=>'2019', 'valor'=>'715.20'
          }]
        }) }

        it { expect(thematic_indicator.organ).to eq(organ) }
        it { expect(thematic_indicator.axis).to eq(axis) }
        it { expect(thematic_indicator.theme).to eq(theme) }
      end
    end
  end
end
