require 'rails_helper'

describe Integration::Servers::Importer do
  let(:arqfun_content_sample) { "03116171514MARIA FATIMA PINHEIRO PESSOA                                                                        DNS 3                                             193301292240260831500004T1998073130.0019820623ESTAGIARIO/BOLSISTA\r\n" }
  let(:arqfun_content_sample_without_funcional_status) { "03116171514MARIA FATIMA PINHEIRO PESSOA                                                                        DNS 3                                             193301292240260831500004T1998073130.0019820623ESTAGIARIO/BOLSISTA\r\n" }
  let(:arqfin_content_sample) { "03116171514201703000612000000000000000250180000000000000000250180\r\n" }
  let(:rubricas_content_sample) { "00612;IMPOSTO DE REND;D\r\n" } 

  let(:arqfun_content_sample_after_201805) { "03116171514MARIA FATIMA PINHEIRO PESSOA                                                                        DNS 3                                             193301292240260831500004T1998073130.0019820623ESTAGIARIO/BOLSISTA\r\n" }

  let(:arqfun_content_sample_before_201509) { "03116171514MARIA FATIMA PINHEIRO PESSOA                                                                        DNS 3                                             193301292240260831500004T1998073130.0019820623ESTAGIARIO/BOLSISTA\r\n" }

  let(:arqfun_content_sample_before_201412) { "03116171514MARIA FATIMA PINHEIRO PESSOA                                                                        DNS 3                                             193301292240260831500004T1998073130\r\n" }


  let(:supports_organ) { create(:integration_supports_organ, data_termino: nil, codigo_folha_pagamento: '031') }
  let(:finished_supports_organ) { create(:integration_supports_organ, data_termino: Date.today, codigo_folha_pagamento: '031') }

  let(:arqfun_sample) { StringIO.new(arqfun_content_sample).read }
  let(:arqfun_sample_after_201805) { StringIO.new(arqfun_content_sample_after_201805).read }
  let(:arqfun_sample_before_201509) { StringIO.new(arqfun_content_sample_before_201509).read }
  let(:arqfun_sample_before_201412) { StringIO.new(arqfun_content_sample_before_201412).read }

  let(:arqfin_sample) { StringIO.new(arqfin_content_sample).read }
  let(:rubricas_sample) { StringIO.new(rubricas_content_sample).read }

  let(:configuration) { create(:integration_servers_configuration, month: '12/2017') }
  let(:configuration_after_201805) { create(:integration_servers_configuration, month: '06/2018') }
  let(:configuration_before_201509) { create(:integration_servers_configuration, month: '09/2015') }
  let(:configuration_before_201412) { create(:integration_servers_configuration, month: '12/2014') }

  let(:service) { Integration::Servers::Importer.new(configuration.id) }
  let(:service_after_201805) { Integration::Servers::Importer.new(configuration_after_201805.id) }
  let(:service_before_201509) { Integration::Servers::Importer.new(configuration_before_201509.id) }
  let(:service_before_201412) { Integration::Servers::Importer.new(configuration_before_201412.id) }

  context 'before 05/2018' do

    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end

    describe 'self.call' do
      it 'initialize and invoke call method' do
        service = double
        allow(Integration::Servers::Importer).to receive(:new).with(1) { service }
        allow(service).to receive(:call)
        Integration::Servers::Importer.call(1)

        expect(Integration::Servers::Importer).to have_received(:new).with(1)
        expect(service).to have_received(:call)
      end
    end

    describe 'importer' do
      context 'proceed_type' do
        before do
          service.call
        end

        let(:last_proceed_type) { Integration::Servers::ProceedType.last }

        it 'imports data' do
          expect(last_proceed_type.cod_provento).to eq "00612"
          expect(last_proceed_type.dsc_provento).to eq "IMPOSTO DE REND"
          expect(last_proceed_type.dsc_tipo).to eq 'D'
        end
      end

      context 'server' do

        before do
          service.call
        end

        let(:last_server) { Integration::Servers::Server.last }

        it 'imports data' do
          expect(last_server.dsc_funcionario).to eq "MARIA FATIMA PINHEIRO PESSOA"
          expect(last_server.dth_nascimento).to eq Date.parse("19330129")
          expect(last_server.dsc_cpf).to eq "22402608315"
        end
      end

      context 'registration' do
        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'imports data' do

          supports_organ

          service.call

          service.send(:registrations_import, arqfun_sample)

          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.cod_orgao).to eq("031")
          expect(last_registration.dsc_matricula).to eq("16171514")
          expect(last_registration.dsc_funcionario).to eq("MARIA FATIMA PINHEIRO PESSOA")
          expect(last_registration.dsc_cargo).to eq("DNS 3")
          expect(last_registration.dth_nascimento).to eq(Date.parse("19330129"))
          expect(last_registration.dsc_cpf).to eq("22402608315")
          expect(last_registration.num_folha).to eq("0000")
          expect(last_registration.cod_situacao_funcional).to eq("4")
          expect(last_registration.cod_afastamento).to eq("T")
          expect(last_registration.dth_afastamento).to eq(Date.parse("19980731"))
          expect(last_registration.vlr_carga_horaria).to eq(30.00)          
          expect(last_registration.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')          
          expect(last_registration.vdth_admissao).to eq(Date.parse("19820623"))
        end

        it 'dont set finished organ' do
          supports_organ
          finished_supports_organ

          service.call

          service.send(:registrations_import, arqfun_sample)

          expect(last_registration.organ).to eq(supports_organ)
        end
      end

      context 'proceeds' do
        before do
          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_proceed_type) { Integration::Servers::ProceedType.last }
        let(:last_proceed) { Integration::Servers::Proceed.last }

        it 'imports data' do
          expect(last_proceed.cod_orgao).to eq "031"
          expect(last_proceed.dsc_matricula).to eq "16171514"
          expect(last_proceed.num_ano).to eq 2017
          expect(last_proceed.num_mes).to eq 03
          expect(last_proceed.cod_processamento).to eq '0'
          expect(last_proceed.cod_provento).to eq "00612"
          expect(last_proceed.vlr_financeiro).to eq 2501.80
          expect(last_proceed.vlr_vencimento).to eq 2501.80
          expect(last_proceed.proceed_type).to eq(last_proceed_type)
          expect(last_proceed.registration).to eq(last_registration)
        end
      end

      context 'server_salaries' do
        it 'creates month server_salaries' do
          expect(Integration::Servers::ServerSalaries::CreateServerSalaries).to receive(:call).with(configuration.current_month, configuration)

          service.call
        end
      end
    end
  end

  context 'after 05/2018' do
    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample_after_201805)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end


    describe 'importer' do
      context 'registration' do
        before do
          supports_organ

          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'imports data' do
          service.send(:registrations_import, arqfun_sample)

          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.cod_orgao).to eq("031")
          expect(last_registration.dsc_matricula).to eq("16171514")
          expect(last_registration.dsc_funcionario).to eq("MARIA FATIMA PINHEIRO PESSOA")
          expect(last_registration.dsc_cargo).to eq("DNS 3")
          expect(last_registration.dth_nascimento).to eq(Date.parse("19330129"))
          expect(last_registration.dsc_cpf).to eq("22402608315")
          expect(last_registration.num_folha).to eq("0000")
          expect(last_registration.cod_situacao_funcional).to eq("4")
          expect(last_registration.cod_afastamento).to eq("T")
          expect(last_registration.dth_afastamento).to eq(Date.parse("19980731"))
          expect(last_registration.vlr_carga_horaria).to eq(30.00)         
          expect(last_registration.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')
          expect(last_registration.vdth_admissao).to eq(Date.parse("19820623"))
        end
      end
    end
  end

  context 'before 07/2017' do

    # Antes de 2017, não havia o campo status_situacao_funcional. Temos que
    # garantir que esse valor não é sobrescrito caso tenhamos sincronizado
    # depois de 2017 (com valor de situação funcional) e posteriormente seja
    # sincronizado antes de 2017 (sem valor).

    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end


    describe 'importer' do
      context 'registration' do
        before do
          supports_organ

          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'does not overrise status_situacao_funcional' do
          service.send(:registrations_import, arqfun_sample)

          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')

          allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_content_sample_without_funcional_status)

          service.call

          expect(last_registration.reload.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')
        end
      end
    end
  end

  context 'before 09/2015' do
    let(:service) { service_before_201509 }

    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample_before_201509)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end


    describe 'importer' do
      context 'registration' do
        before do
          supports_organ

          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'imports data' do
          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.cod_orgao).to eq("031")
          expect(last_registration.dsc_matricula).to eq("16171514")
          expect(last_registration.dsc_funcionario).to eq("MARIA FATIMA PINHEIRO PESSOA")
          expect(last_registration.dsc_cargo).to eq("DNS 3")
          expect(last_registration.dth_nascimento).to eq(Date.parse("19330129"))
          expect(last_registration.dsc_cpf).to eq("22402608315")
          expect(last_registration.num_folha).to eq("0000")
          expect(last_registration.cod_situacao_funcional).to eq("4")
          expect(last_registration.cod_afastamento).to eq("T")
          expect(last_registration.dth_afastamento).to eq(Date.parse("19980731"))
          expect(last_registration.vlr_carga_horaria).to eq(30.00)
          expect(last_registration.vdth_admissao).to eq(Date.parse("19820623"))
        end
      end
    end
  end

  context 'before 12/2014' do
    let(:service) { service_before_201412 }

    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample_before_201412)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end

    describe 'importer' do
      context 'registration' do
        before do
          supports_organ

          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'imports data' do
          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.cod_orgao).to eq("031")
          expect(last_registration.dsc_matricula).to eq("16171514")
          expect(last_registration.dsc_funcionario).to eq("MARIA FATIMA PINHEIRO PESSOA")
          expect(last_registration.dsc_cargo).to eq("DNS 3")
          expect(last_registration.dth_nascimento).to eq(Date.parse("19330129"))
          expect(last_registration.dsc_cpf).to eq("22402608315")
          expect(last_registration.num_folha).to eq("0000")
          expect(last_registration.cod_situacao_funcional).to eq("4")
          expect(last_registration.cod_afastamento).to eq("T")
          expect(last_registration.dth_afastamento).to eq(Date.parse("19980731"))
          expect(last_registration.vlr_carga_horaria).to eq(30.00)
          expect(last_registration.vdth_admissao).to eq(nil) 
          
        end
      end
    end
  end

  context 'before 12/2014 does not override data' do
    # Antes de 2015, não havia o campo status_situacao_funcional e vdth_admissao. Temos que
    # garantir que esse valor não é sobrescrito caso tenhamos sincronizado
    # depois de 2015 (com valor de situação funcional) e posteriormente seja
    # sincronizado antes de 2015 (sem valor).

    before do
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:rubricas).and_return(rubricas_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_sample)
      allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfin).and_return(arqfin_sample)

      service.send(:start)
    end

    describe 'importer' do
      context 'registration' do
        before do
          supports_organ

          service.call
        end

        let(:last_registration) { Integration::Servers::Registration.last }
        let(:last_server) { Integration::Servers::Server.last }

        it 'does not overrise status_situacao_funcional' do
          service.send(:registrations_import, arqfun_sample)

          expect(last_registration.organ).to eq(supports_organ)
          expect(last_registration.server).to eq(last_server)

          expect(last_registration.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')
          expect(last_registration.vdth_admissao).to eq(Date.parse("19820623"))

          allow(service.ftp_downloader_seplag).to receive(:download_file).with(:arqfun).and_return(arqfun_content_sample_before_201412)

          service.call

          expect(last_registration.reload.status_situacao_funcional).to eq('ESTAGIARIO/BOLSISTA')
          expect(last_registration.vdth_admissao).to eq(Date.parse("19820623"))
          
        end
      end
    end
  end
end
