require 'rails_helper'

describe Integration::Purchases::Importer do

  let(:configuration) { create(:integration_purchases_configuration) }

  let(:service) { Integration::Purchases::Importer.new(configuration.id) }

  let!(:manager) { create(:integration_supports_management_unit, codigo: '241321') }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Purchases::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Purchases::Importer.call(1)

      expect(Integration::Purchases::Importer).to have_received(:new).with(1)
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
          consulta_compras_response: {
            lista_compras: {
              compras: [
                {
                  numero_publicacao: "2016/24578",
                  numero_viproc: "60019612016",
                  num_termo_participacao: "20160308",
                  cnpj: "07954571003715",
                  nome_resp_compra: "HOSPITAL DE SAUDE MENTAL DE MESSEJANA",
                  uf_resp_compra: "CE",
                  macro_regiao_org: "Metropolitana de Fortaleza",
                  micro_regiao_org: "Fortaleza",
                  municipio_resp_compra: "Fortaleza",
                  cpf_cnpj_fornecedor: "00466084000153",
                  nome_fornecedor: "SUPRIMAX COMERCIAL LTDA - EPP",
                  tipo_fornecedor: "EPP",
                  uf_fornecedor: "Ceará",
                  macro_regiao_fornecedor: "Metropolitana de Fortaleza",
                  micro_regiao_fornecedor: "Fortaleza",
                  municipio_fornecedor: "Fortaleza",
                  tipo_material_servico: "Material",
                  nome_grupo: "ARTIGOS E UTENSILIOS DE ESCRITORIO",
                  codigo_item: "11690",
                  descricao_item: "EXTRATOR DE GRAMPOS, AÇO CROMADO, 15 CM, EMBALAGEM COM IDENTIFICAÇAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE",
                  unidade_fornecimento: "CARTELA 1.0 UNIDADE ",
                  marca: "LYKE",
                  natureza_aquisicao: "MATERIAL DE CONSUMO",
                  tipo_aquisicao: "MATERIAL DE EXPEDIENTE",
                  sistematica_aquisicao: "PREGÃO",
                  forma_aquisicao: "ELETRÃ”NICO",
                  tratamento_diferenciado: false,
                  data_publicacao: "Tue, 24 Jan 2017 00:00:00 -0300",
                  quantidade_estimada: " 30,0",
                  valor_unitario: "0.91",
                  data_finalizada: "Thu, 09 Feb 2017 00:00:00 -0300",
                  valor_total_melhor_lance: "27.30",
                  valor_estimado: "2.26",
                  valor_total_estimado: "67.80",
                  aquisicao_contrato: false,
                  prazo_entrega: "0",
                  prazo_pagamento: "0",
                  exige_amostras: "Não",
                  data_carga: "Tue, 23 Jan 2018 00:00:00 -0300",
                  ano: "2017",
                  mes: "2",
                  ano_mes: "201702",
                  codigo_classe_material: "5",
                  nome_classe_material: "ARTIGOS PARA ESCRITORIO",
                  registro_preco: "Não",
                  unid_compra_regiao_planej: "Grande Fortaleza",
                  fornecedor_regiao_planejamento: "Grande Fortaleza",
                  unidade_gestora: "241321",
                  grupo_lote: "1",
                  descricao_item_referencia: "EXTRATOR DE GRAMPOS, 15 CM, ACO CROMADO, EMBALAGEM COM IDENTIFICACAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE",
                  id_item_aquisicao: "113215",
                  cod_item_referencia: "11690"
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
          mes: Date.parse(configuration.month).month,
          ano: Date.parse(configuration.month).year
        }
      end

      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:consulta_compras, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call
        configuration.reload
      end

      describe 'fail' do
        let(:body) do
          { consulta_compras_response: { } }
        end

        it { expect(Integration::Purchases::Purchase.count).to eq(0) }
      end

      describe 'create purchase' do
        let(:purchase) { Integration::Purchases::Purchase.last }

        it { expect(Integration::Purchases::Purchase.count).to eq(1) }
      end

      describe 'unidade_gestora' do
        let(:purchase) { Integration::Purchases::Purchase.last }

        it { expect(purchase.manager).to eq(manager) }
      end

      describe 'with items = Array' do
        describe 'create purchase' do
          let(:purchase) { Integration::Purchases::Purchase.last }

          it { expect(purchase.numero_publicacao).to eq("2016/24578") }
          it { expect(purchase.numero_viproc).to eq("60019612016") }
          it { expect(purchase.num_termo_participacao).to eq("20160308") }
          it { expect(purchase.cnpj).to eq("07954571003715") }
          it { expect(purchase.nome_resp_compra).to eq("HOSPITAL DE SAUDE MENTAL DE MESSEJANA") }
          it { expect(purchase.uf_resp_compra).to eq("CE") }
          it { expect(purchase.macro_regiao_org).to eq("Metropolitana de Fortaleza") }
          it { expect(purchase.micro_regiao_org).to eq("Fortaleza") }
          it { expect(purchase.municipio_resp_compra).to eq("Fortaleza") }
          it { expect(purchase.cpf_cnpj_fornecedor).to eq("00466084000153") }
          it { expect(purchase.nome_fornecedor).to eq("SUPRIMAX COMERCIAL LTDA - EPP") }
          it { expect(purchase.tipo_fornecedor).to eq("EPP") }
          it { expect(purchase.uf_fornecedor).to eq("Ceará") }
          it { expect(purchase.macro_regiao_fornecedor).to eq("Metropolitana de Fortaleza") }
          it { expect(purchase.micro_regiao_fornecedor).to eq("Fortaleza") }
          it { expect(purchase.municipio_fornecedor).to eq("Fortaleza") }
          it { expect(purchase.tipo_material_servico).to eq("Material") }
          it { expect(purchase.nome_grupo).to eq("ARTIGOS E UTENSILIOS DE ESCRITORIO") }
          it { expect(purchase.codigo_item).to eq("11690") }
          it { expect(purchase.descricao_item).to eq("EXTRATOR DE GRAMPOS, AÇO CROMADO, 15 CM, EMBALAGEM COM IDENTIFICAÇAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE") }
          it { expect(purchase.unidade_fornecimento).to eq("CARTELA 1.0 UNIDADE ") }
          it { expect(purchase.marca).to eq("LYKE") }
          it { expect(purchase.natureza_aquisicao).to eq("MATERIAL DE CONSUMO") }
          it { expect(purchase.tipo_aquisicao).to eq("MATERIAL DE EXPEDIENTE") }
          it { expect(purchase.sistematica_aquisicao).to eq("PREGÃO") }
          it { expect(purchase.forma_aquisicao).to eq("ELETRÃ”NICO") }
          it { expect(purchase.tratamento_diferenciado).to eq(false) }
          it { expect(purchase.data_publicacao).to eq("Tue, 24 Jan 2017 00:00:00 -0300") }
          it { expect(purchase.quantidade_estimada).to eq(" 30,0".to_d) }
          it { expect(purchase.valor_unitario).to eq("0.91".to_d) }
          it { expect(purchase.data_finalizada).to eq("Thu, 09 Feb 2017 00:00:00 -0300") }
          it { expect(purchase.valor_total_melhor_lance).to eq("27.3".to_d) }
          it { expect(purchase.valor_estimado).to eq("2.26".to_d) }
          it { expect(purchase.valor_total_estimado).to eq("67.8".to_d) }
          it { expect(purchase.aquisicao_contrato).to eq(false) }
          it { expect(purchase.prazo_entrega).to eq("0") }
          it { expect(purchase.prazo_pagamento).to eq("0") }
          it { expect(purchase.exige_amostras).to eq("Não") }
          it { expect(purchase.data_carga).to eq("Tue, 23 Jan 2018 00:00:00 -0300") }
          it { expect(purchase.ano).to eq("2017") }
          it { expect(purchase.mes).to eq("2") }
          it { expect(purchase.ano_mes).to eq("201702") }
          it { expect(purchase.codigo_classe_material).to eq("5") }
          it { expect(purchase.nome_classe_material).to eq("ARTIGOS PARA ESCRITORIO") }
          it { expect(purchase.registro_preco).to eq("Não") }
          it { expect(purchase.unid_compra_regiao_planej).to eq("Grande Fortaleza") }
          it { expect(purchase.fornecedor_regiao_planejamento).to eq("Grande Fortaleza") }
          it { expect(purchase.unidade_gestora).to eq("241321") }
          it { expect(purchase.grupo_lote).to eq("1") }
          it { expect(purchase.descricao_item_referencia).to eq("EXTRATOR DE GRAMPOS, 15 CM, ACO CROMADO, EMBALAGEM COM IDENTIFICACAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE") }
          it { expect(purchase.id_item_aquisicao).to eq(113215) }
          it { expect(purchase.cod_item_referencia).to eq("11690") }
        end
      end
    end
  end
end
