  require 'rails_helper'

describe OpenData::Importer do
  let(:data_item) do
    create(:data_item, :receitas)
  end

  let(:service) { OpenData::Importer.new(data_item.id) }

  let(:message) { Rack::Utils.parse_nested_query("mes=#{Date.current.month}") }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(OpenData::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      OpenData::Importer.call(1)

      expect(OpenData::Importer).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to client' do
      expect(service.client).to be_an_instance_of(Savon::Client)
    end

    it 'responds to data_item' do
      expect(service.data_item).to eq(data_item)
    end

    describe 'error' do
      before do
        allow_any_instance_of(Savon::SOAPFault).to receive(:to_s).and_return('ops')
        allow_any_instance_of(EOFError).to receive(:to_s).and_return('ops')
        allow_any_instance_of(Net::ReadTimeout).to receive(:to_s).and_return('ops')
      end

      after do
        data_item.reload
        expect(data_item.last_error).to eq('ops')
        expect(data_item).to be_status_fail
      end

      let(:http) { double() }

      let(:nori) { double() }

      it 'logs Savon::SOAPFault' do
        allow(service).to receive(:import) { raise Savon::SOAPFault.new(http, nori) }

        service.call
      end

      it 'logs EOFError' do
        # EOFError é disparado quando algum serviço não responde. (talvez nos timeouts)
        allow(service).to receive(:import) { raise EOFError }

        service.call
      end

      it 'logs Net::ReadTimeout' do
        allow(service).to receive(:import) { raise Net::ReadTimeout }

        service.call
      end
    end
  end

  describe 'call' do
    describe 'xml response' do
      let(:body) do
        {
          mes_exercicio_response: {
            saldos_orcamentarios: {
              saldo_orcamentario: [
                {
                  dt_atual: 'XXXX-XX-XX',
                  ano_mes_competencia: 'XX-XXXX',
                  cod_unid_gestora: 'XXX',
                  cod_unid_orcam: 'XXX',
                  cod_funcao: 'XXX',
                  cod_subfuncao: 'XXX',
                  cod_programa: 'XXX',
                  cod_acao: 'XXX',
                  cod_localizacao_gasto: 'XXX',
                  cod_natureza_desp: 'XXX',
                  cod_fonte: 'XX',
                  id_uso: 'XXX',
                  cod_grupo_desp: 'XXX',
                  cod_tp_orcam: 'XXX',
                  cod_esfera_orcam: 'XXX',
                  cod_grupo_fin: 'XXX',
                  classif_orcam_reduz: 'XXX',
                  classif_orcam_completa: 'XXX',
                  val_inicial: 'XXX.XX',
                  val_suplementado: 'XXX.XX',
                  val_anulado: 'XXX.XX',
                  val_transferido_recebido: 'XXX.XX',
                  val_transferido_concedido: 'XXX.XX',
                  val_contido: 'XXX.XX',
                  val_contido_anulado: 'XXX.XX',
                  val_descentralizado: 'XXX.XX',
                  val_descentralizado_anulado: 'XXX.XX',
                  val_empenhado: 'XXX.XX',
                  val_empenhado_anulado: 'XXX.XX',
                  val_liquidado: 'XXX.XX',
                  val_liquidado_anulado: 'XXX.XX',
                  val_pago: 'XXX.XX',
                  val_pago_anulado: 'XXX.XX',
                  valorLiquidadoRetido: 'NNN.NN',
                  valorLiquidadoRetidoAnulado: 'NNN.NN',
                  address: {
                    rua: 'Rua 1',
                    numero: '123',
                    bairro: 'Bela vista'
                  }
                }
              ]
            }
          }
        }
      end

      let(:saldo_orcamentario) {
        body[:mes_exercicio_response][:saldos_orcamentarios][:saldo_orcamentario]
      }

      let(:csv_header) do
        saldo_orcamentario[0].except(:address).keys + saldo_orcamentario[0][:address].keys
      end

      let(:csv_body) do
        saldo_orcamentario[0].except(:address).values + saldo_orcamentario[0][:address].values
      end

      let(:csv) do
        "#{csv_header.join(',')}\n" +
        "#{csv_body.join(',')}\n"
      end


      before do
        response = double()
        allow(service.client).to receive(:call).
          with(:mes_exercicio, advanced_typecasting: false, message: message) { response }
        allow(response).to receive(:body) { body }

        service.call

      end

      it 'creates a file' do
        spreadsheet_dir_path = Rails.root.to_s + "/public/files/downloads/integration/open_data/data_items/#{data_item.id}/"

        date = Date.current.strftime('%Y_%m_%d')
        data_item_name = data_item.document_public_filename.gsub(/\s/, '_').downcase

        document_filename = "importacao_#{data_item_name}_#{date}.csv"

        spreadsheet_file_path = "#{spreadsheet_dir_path}/#{document_filename}"

        expect(File.exist?(spreadsheet_file_path)).to be_truthy
      end

      it 'changes data_item status' do
        expect(service.data_item.status).to eq('status_success')
      end
    end

    describe 'data_item response' do
      let(:data_item) { create(:data_item, :countries) }

      let(:body) do
        {
          get_countries_response: {
            get_countries_result: "<NewDataSet><Table><Name>Afghanistan</Name></Table><Table><Name>Brazil</Name></Table></NewDataSet>"
          }
        }
      end

      let(:csv) do
        "Name\nAfghanistan\nBrazil\n"
      end

      before do
        response = double()
        allow(service.client).to receive(:call) { response }
        allow(response).to receive(:body) { body }

        service.call

      end

      it 'creates a file' do
        spreadsheet_dir_path = Rails.root.to_s + "/public/files/downloads/integration/open_data/data_items/#{data_item.id}/"

        document_filename = data_item.document_public_filename

        spreadsheet_file_path = "#{spreadsheet_dir_path}/#{document_filename}"

        expect(File.exist?(spreadsheet_dir_path)).to be_truthy
      end
    end
  end
end
