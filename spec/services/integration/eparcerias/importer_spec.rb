require 'rails_helper'

describe Integration::Eparcerias::Importer do

  subject(:service) { Integration::Eparcerias::Importer.new(configuration.id) }

  let(:configuration) { create(:integration_eparcerias_configuration) }

  let(:convenant) { create(:integration_contracts_convenant, cod_plano_trabalho: 'PLANO/01') }

  describe 'scope' do
    it 'filters convenant by import_type' do
      active_convenant = create(:integration_contracts_convenant, data_assinatura: Date.today - 1.year, data_termino: Date.today + 1.year)
      inactive_convenant = create(:integration_contracts_convenant, data_assinatura: Date.today - 1.year, data_termino: Date.today - 6.months)

      configuration.import_type = :import_all
      configuration.save
      expect(service.convenants).to match_array([active_convenant, inactive_convenant])

      configuration.import_type = :import_active
      configuration.save
      service = Integration::Eparcerias::Importer.new(configuration.id)

      expect(service.convenants).to eq([active_convenant])
    end
  end

  describe 'imports ordens bancárias' do
    let(:ordem_bancaria) do
      {
        numero_ordem_bancaria: '20170901000164054',
        tipo_ordem_bancaria: 'Pagamento a Fornecedor',
        nome_benceficiario: 'J C BARRETO E CIA LTDA ME',
        valor_ordem_bancaria: '24395.50',
        data_pagamento: '2017-09-04T00:00:00-03:00'
      }
    end

    let(:body) do
      {
        consulta_ordens_bancarias_response: {
          lista_ordem_bancaria: {
            ordem_bancaria: [ordem_bancaria]
          }
        }
      }
    end

    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        numero_instrumento: convenant.isn_sic
      }
    end

    before do
      transfer_bank_order_response = double()

      allow(service.client).to receive(:call).with(anything, anything) { transfer_bank_order_response }

      allow(service.client).to receive(:call).
        with(:consulta_ordens_bancarias, advanced_typecasting: false, message: message) { transfer_bank_order_response }
      allow(transfer_bank_order_response).to receive(:body) { body }
    end

    describe 'self.call' do
      it 'initialize and invoke call method' do
        service = double
        allow(Integration::Eparcerias::Importer).to receive(:new).with(1) { service }
        allow(service).to receive(:call)
        Integration::Eparcerias::Importer.call(1)

        expect(Integration::Eparcerias::Importer).to have_received(:new).with(1)
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
      before do
        service.call
      end

      describe 'statuses' do
        it 'success' do
          allow(service).to receive(:import).and_return(true)
          service.call
          expect(configuration.reload.status_success?).to be_truthy
        end

        describe 'error' do
          before do
            allow(service).to receive(:import) { raise 'Error' }
            service.call
            configuration.reload
          end

          it { expect(configuration.status_fail?).to be_truthy }

        end
      end
    end

    describe 'import_transfer_bank_orders' do
      it 'creates transfer_bank_orders' do
        expect do
          service.send(:start)
          service.send(:import)

          created = Integration::Eparcerias::TransferBankOrder.last

          expect(created.isn_sic).to eq(convenant.isn_sic)
          expect(created.numero_ordem_bancaria).to eq(ordem_bancaria[:numero_ordem_bancaria])
          expect(created.tipo_ordem_bancaria).to eq(ordem_bancaria[:tipo_ordem_bancaria])
          expect(created.nome_benceficiario).to eq(ordem_bancaria[:nome_benceficiario])
          expect(created.valor_ordem_bancaria).to eq(ordem_bancaria[:valor_ordem_bancaria].to_d)
          expect(created.data_pagamento).to eq(DateTime.parse(ordem_bancaria[:data_pagamento]))
        end.to change(Integration::Eparcerias::TransferBankOrder, :count).by(1)
      end

      it 'creates transfer_bank_orders for Confidential Convenant' do
        convenant.update(confidential: true)

        service.send(:start)
        service.send(:import)

        created = Integration::Eparcerias::TransferBankOrder.last

        expect(convenant.transfer_bank_orders.count).to eq(0)
        expect(Integration::Eparcerias::TransferBankOrder.count).to eq(0)
      end
    end
  end

  describe 'imports anexos dos planos de trabalho' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        numero_plano_trabalho: convenant.cod_plano_trabalho
      }
    end

    let(:body) do
      {
        consulta_anexos_plano_trabalho_response: {
          lista_anexo_plano_trabalho: {
            anexo_arquivo: [anexo_plano_trabalho]
          }
        }
      }
    end

    let(:anexo_plano_trabalho) do
      {
        file_name: 'Plano de Trabalho - SOBEF.PDF',
        file_size: '790183',
        file_type: 'application/x-download',
        file_content: 'JVBERi0xL...',
        description: 'descricao'
      }
    end

    before do
      response = double()

      allow(service.client).to receive(:call).with(anything, anything) { response }

      allow(service.client).to receive(:call).
        with(:consulta_anexos_plano_trabalho, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    # Nota sobre o comentário
    # 
    # Não existe necessiade de baixar o plano de trabalho
    # o mesmo agora é online, fornecido diretamente por URL
    # Veja o model Convenant no projeto SPRC
    #
    # it 'creates work_plan_attachments' do
    #   expect do
    #     file_content = anexo_plano_trabalho[:file_content]

    #     service.send(:start)
    #     service.send(:import)

    #     created = Integration::Eparcerias::WorkPlanAttachment.last

    #     expect(created.isn_sic).to eq(convenant.isn_sic)
    #     expect(created.file_name).to eq(anexo_plano_trabalho[:file_name])
    #     expect(created.file_size).to eq(anexo_plano_trabalho[:file_size].to_i)
    #     expect(created.file_type).to eq(anexo_plano_trabalho[:file_type])
    #     expect(created.description).to eq(anexo_plano_trabalho[:description])

    #     base_path = '/public/files/downloads/integration/eparcerias/work_plan_attachments'

    #     file_path = File.join(Rails.root, "#{base_path}/#{created.id}/#{created.file_name}")

    #     expect(File.read(file_path)).to eq(Base64.decode64(file_content))
    #   end.to change(Integration::Eparcerias::WorkPlanAttachment, :count).by(1)
    # end
  end

  describe 'imports situação da prestação de contas' do
    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        numero_instrumento: convenant.isn_sic
      }
    end

    let(:body) do
      {
        consulta_situacao_prestacao_contas_response: {
          situacao_prestacao_contas: 'teste'
        }
      }
    end

    before do
      response = double()

      allow(service.client).to receive(:call).with(anything, anything) { response }

      allow(service.client).to receive(:call).
        with(:consulta_situacao_prestacao_contas, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.send(:start)
    end

    it 'creates accountability' do
      service.send(:start)
      service.send(:import)

      expect(convenant.reload.accountability_status).to eq('teste')
    end
  end
end
