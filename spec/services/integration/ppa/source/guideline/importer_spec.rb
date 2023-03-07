require 'rails_helper'

describe Integration::PPA::Source::Guideline::Importer do

  let(:configuration) do
    create(:integration_ppa_source_guideline_configuration)
  end

  let(:service) { Integration::PPA::Source::Guideline::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::PPA::Source::Guideline::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::PPA::Source::Guideline::Importer.call(1)

      expect(Integration::PPA::Source::Guideline::Importer).to have_received(:new).with(1)
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
          listagem_diretrizes_response: {
            lista_diretrizes: {
              diretriz: [
                {
                  codigo_regiao: '04',
                  descricao_regiao: 'GRANDE FORTALEZA',
                  descricao_objetivo_estrategico: 'Reduzir a pobreza e as desigualdades sociais e regionais.',
                  descricao_estrategia: 'Integrar as políticas intersetoriais de assistência social, habitação, segurança alimentar e nutricional, educação, saúde, esporte e lazer e desenvolvimento territorial.',
                  codigo_ppa_objetivo_estrategico: '03.06',
                  codigo_ppa_estrategia: '03.06.15',
                  codigo_eixo: '1',
                  descricao_eixo: 'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS',
                  codigo_tema: '1.02',
                  descricao_tema: 'PLANEJAMENTO E GESTÃO',
                  codigo_programa: '015',
                  descricao_programa: 'GOVERNANÇA DO PACTO POR UM CEARÁ PACÍFICO',
                  codigo_ppa_iniciativa: '065.1.06',
                  descricao_ppa_iniciativa: 'Gestão das ações desenvolvidas com foco no combate à pobreza e inclusão social.',
                  codigo_acao: '-',
                  descricao_acao: '-',
                  codigo_produto: '425',
                  descricao_produto: 'PLANO ELABORADO',
                  descricao_portal: '-',
                  prioridade_regional: '-',
                  ordem_prioridade: '0',
                  descricao_referencia: 'Sem Período Concluído para o Ano',
                  valor_programado_ano1: '0',
                  valor_programado_ano2: '0',
                  valor_programado_ano3: '0',
                  valor_programado_ano4: '0',
                  valor_programado1619_ar: '0',
                  valor_programado1619_dr: '0',
                  valor_realizado_ano1: '0',
                  valor_realizado_ano2: '0',
                  valor_realizado_ano3: '0',
                  valor_realizado_ano4: '0',
                  valor_realizado1619_ar: '0',
                  valor_realizado1619_dr: '0',
                  valor_lei2016: '0',          # XXX atributo renomeado para _ano1
                  valor_lei2017: '0',          # XXX atributo renomeado para _ano2
                  valor_lei2018: '0',          # XXX atributo renomeado para _ano3
                  valor_lei2019: '0',          # XXX atributo renomeado para _ano4
                  valor_lei_creditos2016: '0', # XXX atributo renomeado para _ano1
                  valor_lei_creditos2017: '0', # XXX atributo renomeado para _ano2
                  valor_lei_creditos2018: '0', # XXX atributo renomeado para _ano3
                  valor_lei_creditos2019: '0', # XXX atributo renomeado para _ano4
                  valor_empenhado2016: '0',    # XXX atributo renomeado para _ano1
                  valor_empenhado2017: '0',    # XXX atributo renomeado para _ano2
                  valor_empenhado2018: '0',    # XXX atributo renomeado para _ano3
                  valor_empenhado2019: '0',    # XXX atributo renomeado para _ano4
                  valor_pago2016: '0',         # XXX atributo renomeado para _ano1
                  valor_pago2017: '0',         # XXX atributo renomeado para _ano2
                  valor_pago2018: '0',         # XXX atributo renomeado para _ano3
                  valor_pago2019: '0'          # XXX atributo renomeado para _ano4
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
          regiao: configuration.region
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:listagem_diretrizes, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'statuses' do
        it { expect(configuration.status_success?).to be_truthy }

        describe 'error' do
          before do
            allow(service).to receive(:import_resource) { raise 'Error' }
            service.call
            configuration.reload
          end

          it { expect(configuration.status_fail?).to be_truthy }
        end
      end

      describe 'create guideline' do
        let(:guideline) { PPA::Source::Guideline.last }

        it { expect(guideline.codigo_regiao).to eq('04') }
        it { expect(guideline.descricao_regiao).to eq('GRANDE FORTALEZA') }
        it { expect(guideline.descricao_objetivo_estrategico).to eq('Reduzir a pobreza e as desigualdades sociais e regionais.') }
        it { expect(guideline.descricao_estrategia).to eq('Integrar as políticas intersetoriais de assistência social, habitação, segurança alimentar e nutricional, educação, saúde, esporte e lazer e desenvolvimento territorial.') }
        it { expect(guideline.codigo_ppa_objetivo_estrategico).to eq('03.06') }
        it { expect(guideline.codigo_ppa_estrategia).to eq('03.06.15') }
        it { expect(guideline.codigo_eixo).to eq('1') }
        it { expect(guideline.descricao_eixo).to eq('CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS') }
        it { expect(guideline.codigo_tema).to eq('1.02') }
        it { expect(guideline.descricao_tema).to eq('PLANEJAMENTO E GESTÃO') }
        it { expect(guideline.codigo_programa).to eq('015') }
        it { expect(guideline.descricao_programa).to eq('GOVERNANÇA DO PACTO POR UM CEARÁ PACÍFICO') }
        it { expect(guideline.codigo_ppa_iniciativa).to eq('065.1.06') }
        it { expect(guideline.descricao_ppa_iniciativa).to eq('Gestão das ações desenvolvidas com foco no combate à pobreza e inclusão social.') }
        it { expect(guideline.codigo_acao).to eq('-') }
        it { expect(guideline.descricao_acao).to eq('-') }
        it { expect(guideline.codigo_produto).to eq('425') }
        it { expect(guideline.descricao_produto).to eq('PLANO ELABORADO') }
        it { expect(guideline.descricao_portal).to eq('-') }
        it { expect(guideline.prioridade_regional).to eq('-') }
        it { expect(guideline.ordem_prioridade).to eq('0') }
        it { expect(guideline.descricao_referencia).to eq('Sem Período Concluído para o Ano') }
        it { expect(guideline.valor_programado_ano1).to eq(0.0) }
        it { expect(guideline.valor_programado_ano2).to eq(0.0) }
        it { expect(guideline.valor_programado_ano3).to eq(0.0) }
        it { expect(guideline.valor_programado_ano4).to eq(0.0) }
        it { expect(guideline.valor_programado1619_ar).to eq(0.0) }
        it { expect(guideline.valor_programado1619_dr).to eq(0.0) }
        it { expect(guideline.valor_realizado_ano1).to eq(0.0) }
        it { expect(guideline.valor_realizado_ano2).to eq(0.0) }
        it { expect(guideline.valor_realizado_ano3).to eq(0.0) }
        it { expect(guideline.valor_realizado_ano4).to eq(0.0) }
        it { expect(guideline.valor_realizado1619_ar).to eq(0.0) }
        it { expect(guideline.valor_realizado1619_dr).to eq(0.0) }
        it { expect(guideline.valor_lei_ano1).to eq 0.0 }          # XXX atributo renomeado de _2016
        it { expect(guideline.valor_lei_ano2).to eq 0.0 }          # XXX atributo renomeado de _2017
        it { expect(guideline.valor_lei_ano3).to eq 0.0 }          # XXX atributo renomeado de _2018
        it { expect(guideline.valor_lei_ano4).to eq 0.0 }          # XXX atributo renomeado de _2019
        it { expect(guideline.valor_lei_creditos_ano1).to eq 0.0 } # XXX atributo renomeado de _2016
        it { expect(guideline.valor_lei_creditos_ano2).to eq 0.0 } # XXX atributo renomeado de _2017
        it { expect(guideline.valor_lei_creditos_ano3).to eq 0.0 } # XXX atributo renomeado de _2018
        it { expect(guideline.valor_lei_creditos_ano4).to eq 0.0 } # XXX atributo renomeado de _2019
        it { expect(guideline.valor_empenhado_ano1).to eq 0.0 }    # XXX atributo renomeado de _2016
        it { expect(guideline.valor_empenhado_ano2).to eq 0.0 }    # XXX atributo renomeado de _2017
        it { expect(guideline.valor_empenhado_ano3).to eq 0.0 }    # XXX atributo renomeado de _2018
        it { expect(guideline.valor_empenhado_ano4).to eq 0.0 }    # XXX atributo renomeado de _2019
        it { expect(guideline.valor_pago_ano1).to eq 0.0 }         # XXX atributo renomeado de _2016
        it { expect(guideline.valor_pago_ano2).to eq 0.0 }         # XXX atributo renomeado de _2017
        it { expect(guideline.valor_pago_ano3).to eq 0.0 }         # XXX atributo renomeado de _2018
        it { expect(guideline.valor_pago_ano4).to eq 0.0 }         # XXX atributo renomeado de _2019

        it { expect(guideline.ano).to eq(configuration.year) }
      end
    end
  end
end
