require 'rails_helper'

describe Integration::Constructions::DaeImporter do

  let(:configuration) { create(:integration_constructions_configuration) }

  let(:logger) { Logger.new('log/test_integrations_importer.log') }

  let(:service) { Integration::Constructions::DaeImporter.new(configuration.id, logger) }

  let(:dae_ws_attributes) {
    {
      :id_obra=>7244,
      :codigo_obra=>"0010201100",
      :contratada=>"PODIUM",
      :data_fim_previsto=>"Thu, 28 Sep 2017",
      :data_inicio=>"Fri, 24 Apr 2015",
      :data_ordem_servico=>"Fri, 24 Apr 2015",
      :descricao=>"OBRA 1ª ETAPA DA URBANIZAÇÃO DO COMPLEXO POLIESPORTIVO CAMPUS ITAPERI E URBANIZAÇÃO DO HOSPITAL VETERINÁRIO DA UECE EM FORTALEZA-CE",
      :dias_aditivado=>709,
      :latitude=>" -3.795659",
      :longitude=>"38.555633",
      :municipio=>"FORTALEZA",
      :numero_licitacao=>"20140001",
      :numero_ordem_servico=>"041/2015",
      :numero_sacc=>"940834",
      :percentual_executado=>"89.86",
      :prazo_inicial=>180,
      :secretaria=>"FUNECE",
      :status=>"Em Execução",
      :tipo_contrato=>"Obra",
      :valor=>"2275667.44"
    }
  }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Constructions::DaeImporter).to receive(:new).with(1, logger) { service }
      allow(service).to receive(:call)
      Integration::Constructions::DaeImporter.call(1, logger)

      expect(Integration::Constructions::DaeImporter).to have_received(:new).with(1, logger)
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
            obra: [ dae_ws_attributes ]
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

    let(:measurement_body) do
      {
        consulta_obra_medicao_response: {
          lista_obras_medicoes: {
            obra_medicao: [
              {
                id: "168493",
                id_medicao: "2628",
                codigo_obra: "0010201100",
                ano_mes: "201106",
                data_inicio: "Tue, 14 Jun 2011 00:00:00 -0300",
                data_fim: "Mon, 20 Jun 2011 00:00:00 -0300",
                numero_medicao: "1",
                valor_medido: "66556.69"
              },
              {
                id: "168499",
                id_medicao: "2629",
                codigo_obra: "0010201101",
                ano_mes: "201109",
                data_inicio: "Tue, 14 Jun 2019 00:00:00 -0300",
                data_fim: "Mon, 20 Jun 2019 00:00:00 -0300",
                numero_medicao: "9",
                valor_medido: "66556.99"
              }
            ]
          }
        }
      }
    end

    let(:photo_body) do
      {
        consulta_foto_medicao_response: {
          lista_foto_medicao: {
            foto_medicao: [
              {
                id_medicao: 2628,
                codigo_obra: "0010201100",
                descricao_conta_associada: "FUNDAÇÕES E ESTRUTURAS",
                legenda: "Execução de laje da coberta",
                url_foto: "http://sigdae.dae.ce.gov.br/ARQUIVOS/FOTO_MEDICAO_CONTRATADA/2628/61743.jpeg"
              },
              {
                id_medicao: 2623,
                codigo_obra: "0010201100",
                descricao_conta_associada: "FUNDAÇÕES E ESTRUTURAS",
                legenda: "Execução de laje da coberta 2",
                url_foto: "http://sigdae.dae.ce.gov.br/ARQUIVOS/FOTO_MEDICAO_CONTRATADA/2628/61743.jpeg"
              },
              {
                id_medicao: 2628,
                codigo_obra: "0010201102",
                descricao_conta_associada: "FUNDAÇÕES E ESTRUTURAS",
                legenda: "Execução de laje da coberta 3",
                url_foto: "http://sigdae.dae.ce.gov.br/ARQUIVOS/FOTO_MEDICAO_CONTRATADA/2628/61743.jpeg"
              }
            ]
          }
        }
      }
    end

    let(:default_message) do
      { usuario: configuration.user, senha: configuration.password }
    end

    let(:message) { default_message.merge(filtro: '') }

    let(:empty_message) { message }

    let(:measurement_message) do
      default_message.merge(codigo_obra: '0010201100')
    end

    let(:photo_message) do
      default_message.merge(codigo_obra: '0010201100', id_medicao: 2628)
    end

    before do
      response, measurement_response, photo_response = double(), double(), double()

      allow(service.client).to receive(:call).
        with(:consulta_obras, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }

      allow(service.client).to receive(:call).
        with(:consulta_obra_medicao, advanced_typecasting: false, message: measurement_message) { measurement_response }
      allow(measurement_response).to receive(:body) { measurement_body }

      allow(service.client).to receive(:call).
        with(:consulta_foto_medicao, advanced_typecasting: false, message: photo_message) { photo_response }
      allow(photo_response).to receive(:body) { photo_body }

      service.call
      configuration.reload
    end

    describe 'fail' do
      let(:body) { empty_body }

      it { expect(Integration::Constructions::Der.count).to eq(0) }
    end

    describe 'creates dae' do
      it { expect(Integration::Constructions::Dae.count).to eq(1) }

      describe 'data' do
        before { service.call }

        let(:dae) { Integration::Constructions::Dae.last }

        it { expect(dae.id_obra).to eq 7244 }
        it { expect(dae.codigo_obra).to eq "0010201100" }
        it { expect(dae.contratada).to eq "PODIUM" }
        it { expect(dae.data_fim_previsto).to eq Time.zone.parse("Thu, 28 Sep 2017") }
        it { expect(dae.data_inicio).to eq Time.zone.parse("Fri, 24 Apr 2015") }
        it { expect(dae.data_ordem_servico).to eq Time.zone.parse("Fri, 24 Apr 2015") }
        it { expect(dae.descricao).to eq "OBRA 1ª ETAPA DA URBANIZAÇÃO DO COMPLEXO POLIESPORTIVO CAMPUS ITAPERI E URBANIZAÇÃO DO HOSPITAL VETERINÁRIO DA UECE EM FORTALEZA-CE" }
        it { expect(dae.dias_aditivado).to eq 709 }
        it { expect(dae.latitude).to eq " -3.795659" }
        it { expect(dae.longitude).to eq "-38.555633" }
        it { expect(dae.municipio).to eq "FORTALEZA" }
        it { expect(dae.numero_licitacao).to eq "20140001" }
        it { expect(dae.numero_ordem_servico).to eq "041/2015" }
        it { expect(dae.numero_sacc).to eq "940834" }
        it { expect(dae.percentual_executado).to eq 89.86 }
        it { expect(dae.prazo_inicial).to eq 180 }
        it { expect(dae.secretaria).to eq "FUNECE" }
        it { expect(dae.status).to eq "Em Execução" }
        it { expect(dae.in_progress?).to be_truthy }
        it { expect(dae.tipo_contrato).to eq "Obra" }
        it { expect(dae.valor).to eq 2275667.44 }
        it { expect(dae.data_changes).to eq(nil) }
        it { expect(dae.resource_status).to eq('new_resource_notificable') }
      end
    end

    describe 'organ association' do

      it 'existent organ' do
        organ = create(:integration_supports_organ, sigla: 'FUNECE', orgao_sfp: false)

        service.call

        dae = Integration::Constructions::Dae.last

        expect(dae.organ_id).to eq(organ.id)
      end

      describe 'organ S. CIDADES' do

        let(:obra_attributes) do
          dae_ws_attributes[:secretaria] = "S. CIDADES"
          dae_ws_attributes
        end

        let(:body) do
          {
            consulta_obras_response: {
              lista_obras: {
                obra: [ obra_attributes ]
              }
            }
          }
        end


        let!(:organ) { create(:integration_supports_organ, sigla: 'SCIDADES', orgao_sfp: false) }

        before { service.call }

        let(:dae) { Integration::Constructions::Dae.last }

        it { expect(dae.organ_id).to eq(organ.id) }
      end

      describe 'organ SESPORTE' do

        let(:obra_attributes) do
          dae_ws_attributes[:secretaria] = "S.ESPORTES"
          dae_ws_attributes
        end

        let(:body) do
          {
            consulta_obras_response: {
              lista_obras: {
                obra: [ obra_attributes ]
              }
            }
          }
        end

        let!(:organ) { create(:integration_supports_organ, sigla: 'SESPORTE', orgao_sfp: false) }

        before { service.call }

        let(:dae) { Integration::Constructions::Dae.last }

        it { expect(dae.organ_id).to eq(organ.id) }
      end

      describe 'organ P.CIVIL' do

        let(:obra_attributes) do
          dae_ws_attributes[:secretaria] = "P.CIVIL"
          dae_ws_attributes
        end

        let(:body) do
          {
            consulta_obras_response: {
              lista_obras: {
                obra: [ obra_attributes ]
              }
            }
          }
        end


        let!(:organ) { create(:integration_supports_organ, sigla: 'PC', orgao_sfp: false) }

        before { service.call }

        let(:dae) { Integration::Constructions::Dae.last }

        it { expect(dae.organ_id).to eq(organ.id) }
      end
    end

    describe 'creates dae measurements' do
      it { expect(Integration::Constructions::Dae::Measurement.count).to eq(1) }

      describe 'data' do
        let(:dae) { Integration::Constructions::Dae.last }
        let(:measurement) { Integration::Constructions::Dae::Measurement.last }

        it { expect(measurement.integration_constructions_dae).to eq dae }
        it { expect(measurement.id_servico).to eq 168493 }
        it { expect(measurement.id_medicao).to eq 2628 }
        it { expect(measurement.codigo_obra).to eq "0010201100" }
        it { expect(measurement.ano_mes).to eq "201106" }
        it { expect(measurement.ano_mes_date).to eq Date.new(2011,06) }
        it { expect(measurement.data_inicio).to eq "Tue, 14 Jun 2011 00:00:00 -0300" }
        it { expect(measurement.data_fim).to eq "Mon, 20 Jun 2011 00:00:00 -0300" }
        it { expect(measurement.numero_medicao).to eq "1" }
        it { expect(measurement.valor_medido).to eq 66556.69 }
        it { expect(measurement.data_changes).to be_nil }
        it { expect(measurement.resource_status).to eq('new_resource_notificable') }
      end
    end

    describe 'creates dae photos' do
      it { expect(Integration::Constructions::Dae::Photo.count).to eq(1) }

      describe 'data' do
        let(:dae) { Integration::Constructions::Dae.last }
        let(:photo) { Integration::Constructions::Dae::Photo.last }

        it { expect(photo.integration_constructions_dae).to eq dae }
        it { expect(photo.id_medicao).to eq 2628 }
        it { expect(photo.codigo_obra).to eq "0010201100" }
        it { expect(photo.descricao_conta_associada).to eq "FUNDAÇÕES E ESTRUTURAS" }
        it { expect(photo.legenda).to eq "Execução de laje da coberta" }
        it { expect(photo.url_foto).to eq "http://sigdae.dae.ce.gov.br/ARQUIVOS/FOTO_MEDICAO_CONTRATADA/2628/61743.jpeg" }
        it { expect(photo.data_changes).to be_nil }
        it { expect(photo.resource_status).to eq('new_resource_notificable') }
      end
    end

    describe 'notify_followers' do
      let(:body) do
        {
          consulta_obras_response: {
            lista_obras: {
              obra: [ dae_ws_attributes ]
            }
          }
        }
      end

      it 'prazo_inicial changed' do
        dae = create(:integration_constructions_dae, dae_ws_attributes)
        dae.update(prazo_inicial: 2)
        changes_hash = {"prazo_inicial"=>[2, 180]}

        service.call

        dae.reload
        expect(dae.data_changes['prazo_inicial']).to match_array(changes_hash['prazo_inicial'])
        expect(dae.resource_status).to eq('updated_resource_notificable')
      end

      it 'prazo_inicial not changed' do
        dae = create(:integration_constructions_dae, dae_ws_attributes)
        dae.update(prazo_inicial: 180)

        service.call

        dae.reload
        expect(dae.data_changes).to eq(nil)
        expect(dae.resource_status).to eq('new_resource_notificable')
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
      expect(Integration::Constructions::Daes::CreateStats).to receive(:call).with(year, month)

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

      today = Date.today
      year = today.year
      month = today.month

      # espera que chame spreadsheet para todos os meses do intervalo no parâmetro
      # de configuração.
      expect(Integration::Constructions::Daes::CreateSpreadsheet).to receive(:call).with(year, month)

      service.call
    end
  end
end
