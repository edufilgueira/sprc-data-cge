require 'rails_helper'

describe Integration::Constructions::DerImporter do

  let(:configuration) { create(:integration_constructions_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Constructions::DerImporter.new(configuration.id, logger) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Constructions::DerImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Constructions::DerImporter.call(1, logger)

      expect(Integration::Constructions::DerImporter).to have_received(:new).with(1, logger)
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
    let(:body) do
      {
        consulta_obras_response: {
          lista_obras: {
            obra: [
              {
                :base=>"10",
                :cerca=>"10",
                :conclusao=>"Mon, 05 Oct 2009",
                :construtora=>"SAMARIA",
                :cor_status=>"#1127b8",
                :data_fim_contrato=>"Tue, 01 Dec 2009",
                :data_fim_previsto=>"Tue, 01 Dec 2009",
                :distrito=>"04 - LIMOEIRO DO NORTE",
                :drenagem=>"100",
                :extensao=>"10.3",
                :id_obra=>309,
                :numero_contrato_der=>"01172008",
                :numero_contrato_ext=>"",
                :numero_contrato_sic=>"189776",
                :obra_darte=>"10",
                :percentual_executado=>100,
                :programa=>"Ceará III (004)",
                :qtd_empregos=>0,
                :qtd_geo_referencias=>1,
                :revestimento=>"10",
                :rodovia=>"CE-371",
                :servicos=>"Restauração: Entr° BR-116 - Palhano",
                :sinalizacao=>"10",
                :status=>"EM LICITAÇÃO",
                :supervisora=>"RNR",
                :terraplanagem=>"100",
                :trecho=>"ENTR. BR-116 - PALHANO",
                :ult_atual=>"Wed, 26 Aug 2009",
                :valor_aprovado=>"2450132.35",
                :latitude=>"03°30,0311' S",
                :longitude=>"039°34,8178' W"
              },
              {
                :base=>"100",
                :cerca=>"100",
                :conclusao=>"Mon, 05 Oct 2009",
                :construtora=>"SAMARIA",
                :cor_status=>"#1127b8",
                :data_fim_contrato=>"Tue, 01 Dec 2009",
                :data_fim_previsto=>"Tue, 01 Dec 2009",
                :distrito=>"04 - LIMOEIRO DO NORTE",
                :drenagem=>"100",
                :extensao=>"10.3",
                :id_obra=>308,
                :numero_contrato_der=>"01172008",
                :numero_contrato_ext=>"",
                :numero_contrato_sic=>"189776",
                :obra_darte=>"100",
                :percentual_executado=>100,
                :programa=>"Ceará III (004)",
                :qtd_empregos=>0,
                :qtd_geo_referencias=>1,
                :revestimento=>"100",
                :rodovia=>"CE-371",
                :servicos=>"Restauração: Entr° BR-116 - Palhano",
                :sinalizacao=>"100",
                :status=>"CONCLUÍDO",
                :supervisora=>"RNR",
                :terraplanagem=>"100",
                :trecho=>"ENTR. BR-116 - PALHANO",
                :ult_atual=>"Wed, 26 Aug 2009",
                :valor_aprovado=>"2450132.35",
                :latitude=>"03°30,0311' S",
                :longitude=>"039°34,8178' W"
              }
            ]
          }
        }
      }
    end

    let(:empty_body) do
      {
        consulta_obras_response: {
          lista_obras: {
            obra: []
          }
        }
      }
    end

    let(:detail_body) do
      {
        consulta_contratos_obras_response: {
          lista_contratos_obras: {
            contrato_obra: {
              data_fim_contrato: "Wed, 20 Aug 2014 00:00:00 -0300",
              data_fim_previsto: "Wed, 20 Aug 2014 00:00:00 -0300",
              data_inicio_obra: "Mon, 01 Jul 2013 00:00:00 -0300",
              data_ordem_servico: "Mon, 01 Jul 2013 00:00:00 -0300",
              dias_adicionado: "0",
              dias_suspenso: "0",
              id_status: "5",
              municipio: "LIMOEIRO DO NORTE",
              numero_contrato_sacc: "189776",
              numero_ordem_servico: "099/2013",
              prazo_inicial: "540",
              status: "CONCLUÍDO",
              total_aditivo: "0.00",
              total_reajuste: "0.00",
              valor_atual: "18262239.38",
              valor_original: "18262239.38",
              valor_pi: "18262239.38"
            }
          }
        }
      }
    end

    let(:measurement_body) do
      {
        consulta_medicoes_obra_response: {
          lista_medicoes_obra: {
            medicao_obra: [
              {
                id_medicao: 5311,
                id_obra: 308,
                id_status: 2,
                ano_mes: "201611",
                numero_contrato_der: "00432016",
                numero_contrato_sac: "189776",
                numero_medicao: 1,
                rodovia: "CE-284",
                status: "CONCLUÍDO",
                status_medicao: "Fechada",
                valor_medido: 148832.28
              }, {
                id_medicao: 5312,
                id_obra: 309,
                id_status: 3,
                ano_mes: "201612",
                numero_contrato_der: "00432017",
                numero_contrato_sac: "189776",
                numero_medicao: 2,
                rodovia: "CE-285",
                status: "CONCLUÍDA",
                status_medicao: "Fechado",
                valor_medido: 148832.30
              }
            ]
          }
        }
      }
    end

    let(:coordinates_body) do
      {
        consulta_obra_por_numero_contrato_sacc_response: {
          obra_por_numero_contrato_sacc: {
            base: "0",
            cerca: "49",
            cnpj_supervisao: "33980905000124",
            construtora: "MACIEL",
            cor_status: "#f50323",
            data_fim_previsto: "Fri, 26 Jul 2019 00:00:00 -0300",
            data_inicio_obra: "Wed, 02 May 2018 00:00:00 -0300",
            data_ordem_servico: "Wed, 02 May 2018 00:00:00 -0300",
            dias_adicionado: "0",
            dias_suspenso: "0",
            distrito: "05 - SANTA QUITÉRIA",
            drenagem: "0",
            extensao: "13.0",
            id_obra: "857",
            id_status: "2",
            latitude: "06°01,8129' S",
            longitude: "038°21,0082' W",
            nr_contrato_der: "00092018",
            nr_contrato_ext:nil,
            nr_contrato_sac: "1041426",
            numero_contrato_supervisao: "00202018",
            numero_contrato_supervisao_sac: "1040974",
            numero_licitacao: "CONPUB.",
            numero_ordem_servico: "052/2018",
            obra_darte: "24",
            percentual_executado: "13",
            prazo_inicial: "450",
            programa: "Programa 003 (Ceará IV)",
            qtd_geo_referencias: "0",
            razao_social_supervisao: "MAGNA ENGENHARIA LTDA",
            revestimento: "0",
            rodovia: "CE-162",
            servicos: "RESTAURAÇÃO:ENTR. CE-253 (PARAMOTI) - ENTR. BR-020",
            sinalizacao: "0",
            status: "EM ANDAMENTO",
            terraplanagem: "16",
            total_aditivo: "0.00",
            total_reajuste: "0.00",
            trecho: "ENTR. CE-253 (PARAMOTI) - ENTR. BR-020",
            ultatual: "Tue, 03 Jul 2018 00:00:00 -0300",
            valor_aprovado: "5336661.17",
            valor_atual: "5336661.19",
            valor_original: "5336661.19",
            valor_pi: "5336661.19"
          }
        }
      }
    end

    let(:default_message) do
      { usuario: configuration.user, senha: configuration.password }
    end

    let(:message) { default_message.merge(filtro: '') }
    let(:empty_message) { message }

    let(:detail_message) do
      default_message.merge(filtro: { numeroContrato: '189776'})
    end

    let(:measurement_message) do
      default_message.merge(numeroContratoSacc: '189776')
    end

    let(:coordinates_message) do
      default_message.merge(numero_contrato_sacc: '189776')
    end

    before do
      response, empty_response, detail_response, measurement_response, coordinates_response = double(), double(), double(), double(), double()

      allow(service.client).to receive(:call).
        with(:consulta_obras, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }

      allow(service.client).to receive(:call).
        with(:consulta_contratos_obras, advanced_typecasting: false, message: detail_message) { detail_response }
      allow(detail_response).to receive(:body) { detail_body }

      allow(service.client).to receive(:call).
        with(:consulta_medicoes_obra, advanced_typecasting: false, message: measurement_message) { measurement_response }
      allow(measurement_response).to receive(:body) { measurement_body }

      allow(service.client).to receive(:call).
        with(:consulta_obra_por_numero_contrato_sacc, advanced_typecasting: false, message: coordinates_message) { coordinates_response }
      allow(coordinates_response).to receive(:body) { coordinates_body }

      service.call
      configuration.reload
    end

    describe 'fail' do
      let(:body) { empty_body }

      it { expect(Integration::Constructions::Der.count).to eq(0) }
    end

    describe 'creates der' do
      it { expect(Integration::Constructions::Der.count).to eq(1) }

      describe 'data' do
        let(:der) { Integration::Constructions::Der.last }

        it { expect(der.base).to eq("100") }
        it { expect(der.cerca).to eq("100") }
        it { expect(der.conclusao).to eq Time.zone.parse("Mon, 05 Oct 2009") }
        it { expect(der.construtora).to eq("SAMARIA") }
        it { expect(der.cor_status).to eq("#1127b8") }
        it { expect(der.data_fim_contrato).to eq Time.zone.parse("Tue, 01 Dec 2009") }
        it { expect(der.data_fim_previsto).to eq Time.zone.parse("Tue, 01 Dec 2009") }
        it { expect(der.distrito).to eq("04 - LIMOEIRO DO NORTE") }
        it { expect(der.drenagem).to eq("100") }
        it { expect(der.extensao).to eq(10.3) }
        it { expect(der.id_obra).to eq(308) }
        it { expect(der.numero_contrato_der).to eq("01172008") }
        it { expect(der.numero_contrato_ext).to eq("") }
        it { expect(der.numero_contrato_sic).to eq("189776") }
        it { expect(der.obra_darte).to eq("100") }
        it { expect(der.percentual_executado).to eq(100) }
        it { expect(der.programa).to eq("Ceará III (004)") }
        it { expect(der.qtd_empregos).to eq(0) }
        it { expect(der.qtd_geo_referencias).to eq(1) }
        it { expect(der.revestimento).to eq("100") }
        it { expect(der.rodovia).to eq("CE-371") }
        it { expect(der.servicos).to eq("Restauração: Entr° BR-116 - Palhano") }
        it { expect(der.sinalizacao).to eq("100") }
        it { expect(der.status).to eq("CONCLUÍDO") }
        it { expect(der.done?).to be_truthy }
        it { expect(der.supervisora).to eq("RNR") }
        it { expect(der.terraplanagem).to eq("100") }
        it { expect(der.trecho).to eq("ENTR. BR-116 - PALHANO") }
        it { expect(der.ult_atual).to eq Time.zone.parse("Wed, 26 Aug 2009") }
        it { expect(der.valor_aprovado).to eq(2450132.35) }
        it { expect(der.latitude).to eq("-6.030215") }
        it { expect(der.longitude).to eq("-38.35013667") }

        context 'with der_contract' do
          it { expect(der.data_fim_contrato).not_to eq Time.zone.parse("Wed 20 Aug 2014") }
          it { expect(der.data_fim_previsto).not_to eq Time.zone.parse("Wed 20 Aug 2014") }
          it { expect(der.data_fim_contrato).to eq Time.zone.parse("Tue, 01 Dec 2009") }
          it { expect(der.data_fim_previsto).to eq Time.zone.parse("Tue, 01 Dec 2009") }
          it { expect(der.data_inicio_obra).to eq Time.zone.parse("Mon 01 Jul 2013") }
          it { expect(der.data_ordem_servico).to eq Time.zone.parse("Mon 01 Jul 2013") }
          it { expect(der.dias_adicionado).to eq 0 }
          it { expect(der.dias_suspenso).to eq 0 }
          it { expect(der.municipio).to eq "LIMOEIRO DO NORTE" }
          it { expect(der.numero_ordem_servico).to eq "099/2013" }
          it { expect(der.prazo_inicial).to eq 540 }
          it { expect(der.status).to eq "CONCLUÍDO" }
          it { expect(der.done?).to be_truthy }
          it { expect(der.total_aditivo).to eq 0.00 }
          it { expect(der.total_reajuste).to eq 0.00 }
          it { expect(der.valor_atual).to eq 18262239.38 }
          it { expect(der.valor_original).to eq 18262239.38 }
          it { expect(der.valor_pi).to eq 18262239.38 }
        end
      end
    end

    describe 'creates der measurements' do
      it { expect(Integration::Constructions::Der::Measurement.count).to eq(1) }

      describe 'data' do
        let(:der) { Integration::Constructions::Der.last }
        let(:measurement) { Integration::Constructions::Der::Measurement.last }

        it { expect(measurement.integration_constructions_der).to eq der }
        it { expect(measurement.id_medicao).to eq 5311 }
        it { expect(measurement.id_obra).to eq 308 }
        it { expect(measurement.id_status).to eq 2 }
        it { expect(measurement.ano_mes).to eq "201611" }
        it { expect(measurement.ano_mes_date).to eq Date.new(2016,11) }
        it { expect(measurement.numero_contrato_der).to eq "00432016" }
        it { expect(measurement.numero_contrato_sac).to eq "189776" }
        it { expect(measurement.numero_medicao).to eq 1 }
        it { expect(measurement.rodovia).to eq "CE-284" }
        it { expect(measurement.status).to eq "CONCLUÍDO" }
        it { expect(measurement.status_medicao).to eq "Fechada" }
        it { expect(measurement.valor_medido).to eq 148832.28 }
        it { expect(measurement.data_changes).to be_nil }
        it { expect(measurement.resource_status).to eq('new_resource_notificable') }
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

      today = Date.today
      year = today.year
      month = today.month

      # espera que chame estatística para todos os meses do intervalo no parâmetro
      # de configuração.
      expect(Integration::Constructions::Ders::CreateStats).to receive(:call).with(year, month)

      service.call
    end
  end

  describe 'create_spreadsheet' do

    let(:body) { {} }

    before do
      response = double()
      allow(service.client).to receive(:call).with(any_args).and_return(response)
      allow(response).to receive(:body) { body }
      service.send(:start)
    end


    it 'create_stats' do

      today = Date.today
      year = today.year
      month = today.month

      # espera que chame spreadsheet para todos os meses do intervalo no parâmetro
      # de configuração.
      expect(Integration::Constructions::Ders::CreateSpreadsheet).to receive(:call).with(year, month)

      service.call
    end
  end
end
