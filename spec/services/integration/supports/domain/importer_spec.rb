require 'rails_helper'

describe Integration::Supports::Domain::Importer do

  let(:configuration) do
    create(:integration_supports_domain_configuration)
  end

  let(:service) { Integration::Supports::Domain::Importer.new(configuration.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Domain::Importer).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Domain::Importer.call(1)
      expect(Integration::Supports::Domain::Importer).to have_received(:new).with(1)
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

  describe 'imports' do

    let(:message) do
      {
        usuario: configuration.user,
        senha: configuration.password,
        exercicio: Date.today.year
      }
    end

    before do

      response = double()
      allow(service.client).to receive(:call).
        with(:consulta_tabela_exercicio, advanced_typecasting: false, message: message) { response }
      allow(response).to receive(:body) { body }
      service.call
      configuration.reload
    end

    describe 'administrative_region' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_regiao_administrativa: {
                regiao_administrativa: [
                  {:codigo_regiao=>"0100000", :titulo=>"CARIRI"}
                ]
              }
            }
          }
        }
      end

      describe 'create administrative_region' do
        let(:administrative_region) { Integration::Supports::AdministrativeRegion.last }

        it { expect(administrative_region.titulo).to eq('CARIRI') }
        it { expect(administrative_region.codigo_regiao).to eq('0100000') }
      end
    end

    describe 'government_program' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_programa_governo: {
                programa_governo: [
                  {:ano_inicio=>"2017", :codigo_programa=>"011", :titulo=>"PROMOÇÃO DA INDÚSTRIA MINERAL"}
                ]
              }
            }
          }
        }
      end

      describe 'create government_program' do
        let(:government_program) { Integration::Supports::GovernmentProgram.last }

        it 'imports data' do
          expect(government_program.titulo).to eq('PROMOÇÃO DA INDÚSTRIA MINERAL')
          expect(government_program.codigo_programa).to eq('011')
          expect(government_program.ano_inicio).to eq(2017)
        end
      end
    end

    describe 'government_action' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_acao_governamental: {
                acao_governamental: [
                  {:codigo_acao=>"00430", :titulo=>"Contribuição Patronal do Poder Executivo - Pessoal Civil"}
                ]
              }
            }
          }
        }
      end

      describe 'create government_action' do
        let(:government_action) { Integration::Supports::GovernmentAction.last }

        it 'imports data' do
          expect(government_action.titulo).to eq('Contribuição Patronal do Poder Executivo - Pessoal Civil')
          expect(government_action.codigo_acao).to eq('00430')
        end
      end
    end

    describe 'product' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_produto: {
                produto: [
                  {:codigo=>"931", :titulo=>"CENTRO ADMINISTRATIVO MUNICIPAL CONSTRUÍDO"}
                ]
              }
            }
          }
        }
      end

      describe 'create product' do
        let(:product) { Integration::Supports::Product.last }

        it 'imports data' do
          expect(product.codigo).to eq('931')
          expect(product.titulo).to eq('CENTRO ADMINISTRATIVO MUNICIPAL CONSTRUÍDO')
        end
      end
    end


    describe 'sub_product' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_sub_produto: {
                sub_produto: [
                  {:codigo=>"8215", :codigo_produto=>"204", :titulo=>"MÓDULO DE GERENCIAMENTO DE SWITCH"}
                ]
              }
            }
          }
        }
      end

      describe 'create sub_product' do
        let(:sub_product) { Integration::Supports::SubProduct.last }


        it 'imports data' do
          expect(sub_product.codigo).to eq('8215')
          expect(sub_product.codigo_produto).to eq('204')
          expect(sub_product.titulo).to eq('MÓDULO DE GERENCIAMENTO DE SWITCH')
        end
      end
    end

    describe 'function' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_funcao: {
                funcao: [
                  {:codigo_funcao=>"01", :titulo=>"LEGISLATIVA"}
                ]
              }
            }
          }
        }
      end

      describe 'create function' do
        let(:function) { Integration::Supports::Function.last }

        it 'imports data' do
          expect(function.codigo_funcao).to eq('01')
          expect(function.titulo).to eq('LEGISLATIVA')
        end
      end
    end

    describe 'sub_function' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_sub_funcao: {
                sub_funcao: [
                  {:codigo_sub_funcao=>"031", :titulo=>"AÇÃO LEGISLATIVA"}
                ]
              }
            }
          }
        }
      end

      describe 'create sub_function' do
        let(:sub_function) { Integration::Supports::SubFunction.last }

        it 'imports data' do
          expect(sub_function.codigo_sub_funcao).to eq('031')
          expect(sub_function.titulo).to eq('AÇÃO LEGISLATIVA')
        end
      end
    end

    describe 'expense_type' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_tipo_despesa: {
                tipo_despesa: [
                  {:codigo=>"21"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_type' do
        let(:expense_type) { Integration::Supports::ExpenseType.last }

        it 'imports data' do
          expect(expense_type.codigo).to eq('21')
        end
      end
    end

    describe 'payment_retention_type' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_tipo_retencao_pagamento: {
                tipo_retencao_pagamento: [
                  {:codigo_retencao=>"01", :titulo=>"SUPSEC - Descontos Previdenciários"}
                ]
              }
            }
          }
        }
      end

      describe 'create payment_retention_type' do
        let(:payment_retention_type) { Integration::Supports::PaymentRetentionType.last }

        it 'imports data' do
          expect(payment_retention_type.codigo_retencao).to eq('01')
          expect(payment_retention_type.titulo).to eq('SUPSEC - Descontos Previdenciários')
        end
      end
    end

    describe 'management_unit' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_unidade_gestora: {
                unidade_gestora: [
                  { :cgf=>"069328471",
                    :cnpj=>"06750525000120",
                    :codigo=>"010001",
                    :codigo_credor=>"00012101",
                    :poder=>"LEGISLATIVO",
                    :sigla=>"ASSEMBLEIA",
                    :tipo_administracao=>"DIRETA",
                    :tipo_de_ug=>"SECRETARIA",
                    :titulo=>"ASSEMBLEIA LEGISLATIVA"
                  }
                ]
              }
            }
          }
        }
      end

      describe 'create management_unit' do
        let(:management_unit) { Integration::Supports::ManagementUnit.last }

        it 'imports data' do
          expect(management_unit.cgf).to eq('069328471')
          expect(management_unit.cnpj).to eq('06750525000120')
          expect(management_unit.codigo).to eq('010001')
          expect(management_unit.codigo_credor).to eq('00012101')
          expect(management_unit.poder).to eq('LEGISLATIVO')
          expect(management_unit.sigla).to eq('ASSEMBLEIA')
          expect(management_unit.tipo_administracao).to eq('DIRETA')
          expect(management_unit.tipo_de_ug).to eq('SECRETARIA')
          expect(management_unit.titulo).to eq('ASSEMBLEIA LEGISLATIVA')
        end
      end
    end

    describe 'budget_unit' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_unidade_orcamentaria: {
                unidade_orcamentaria: [
                  {:codigo_unidade_gestora=>"010001", :codigo_unidade_orcamentaria=>"01100001", :titulo=>"ADMINISTRAÇÃO SUPERIOR DA ASSEMBLÉIA"}
                ]
              }
            }
          }
        }
      end

      describe 'create budget_unit' do
        let(:budget_unit) { Integration::Supports::BudgetUnit.last }

        it 'imports data' do
          expect(budget_unit.codigo_unidade_gestora).to eq('010001')
          expect(budget_unit.codigo_unidade_orcamentaria).to eq('01100001')
          expect(budget_unit.titulo).to eq('ADMINISTRAÇÃO SUPERIOR DA ASSEMBLÉIA')
        end
      end
    end

    describe 'revenue_nature' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              ano_exercicio: 2019,
              lista_natureza_receita: {
                natureza_receita: [
                  {:codigo=>"100000000", :descricao=>"Receita Orçamentária"}
                ]
              }
            }
          }
        }
      end

      describe 'create revenue_nature' do

        let(:revenue_nature) { Integration::Supports::RevenueNature.last }

        it 'imports data' do
          expect(revenue_nature.codigo).to eq('100000000')
          expect(revenue_nature.descricao).to eq('Receita Orçamentária')
        end
      end
    end

    describe 'expense_nature' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_natureza_despesa: {
                natureza_despesa: [
                  {:codigo_natureza_despesa=>"30000000", :titulo=>"DESPESAS CORRENTES"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_nature' do
        let(:expense_nature) { Integration::Supports::ExpenseNature.last }

        it 'imports data' do
          expect(expense_nature.codigo_natureza_despesa).to eq('30000000')
          expect(expense_nature.titulo).to eq('DESPESAS CORRENTES')
        end
      end
    end

    describe 'expense_nature_item' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_item_natureza_despesa: {
                item_natureza_despesa: [
                  {:codigo_item_natureza=>"31900100001", :titulo=>"Proventos Pessoal Civil"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_nature_item' do
        let(:expense_nature_item) { Integration::Supports::ExpenseNatureItem.last }

        it 'imports data' do
          expect(expense_nature_item.codigo_item_natureza).to eq('31900100001')
          expect(expense_nature_item.titulo).to eq('Proventos Pessoal Civil')
        end
      end
    end

    describe 'expense_nature_group' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_grupo_natureza_despesa: {
                grupo_natureza_despesa: [
                  {:codigo_grupo_natureza=>"0", :titulo=>"RESERVA DE CONTINGÊNCIA"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_nature_group' do
        let(:expense_nature_group) { Integration::Supports::ExpenseNatureGroup.last }

        it 'imports data' do
          expect(expense_nature_group.codigo_grupo_natureza).to eq('0')
          expect(expense_nature_group.titulo).to eq('RESERVA DE CONTINGÊNCIA')
        end
      end
    end

    describe 'expense_finance_group' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_grupo_financeiro: {
                grupo_financeiro: [
                  {:codigo_grupo_financeiro=>"10", :titulo=>"DESPESAS ORDINARIAS"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_finance_group' do
        let(:expense_finance_group) { Integration::Supports::FinanceGroup.last }

        it 'imports data' do
          expect(expense_finance_group.codigo_grupo_financeiro).to eq('10')
          expect(expense_finance_group.titulo).to eq('DESPESAS ORDINARIAS')
        end
      end
    end

    describe 'application_modality' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_modalidade_aplicacao: {
                modalidade_aplicacao: [
                  {:codigo_modalidade=>"00", :titulo=>"RESERVA DE CONTINGÊNCIA"}
                ]
              }
            }
          }
        }
      end

      describe 'create application_modality' do
        let(:application_modality) { Integration::Supports::ApplicationModality.last }

        it 'imports data' do
          expect(application_modality.codigo_modalidade).to eq('00')
          expect(application_modality.titulo).to eq('RESERVA DE CONTINGÊNCIA')
        end
      end
    end

    describe 'resource_source' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_fonte_recurso: {
                fonte_recurso: [
                  {:codigo_fonte=>nil, :titulo=>"OUTRAS FONTES"}
                ]
              }
            }
          }
        }
      end

      describe 'create resource_source' do
        let(:resource_source) { Integration::Supports::ResourceSource.last }

        it 'imports data' do
          expect(resource_source.codigo_fonte).to eq(nil)
          expect(resource_source.titulo).to eq('OUTRAS FONTES')
        end
      end
    end

    describe 'qualified_resource_source' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_fonte_recurso_qualificada: {
                fonte_recurso_qualificada: [
                  {:codigo=>"10000", :titulo=>"TESOURO, RECURSOS ORDINÁRIOS"}
                ]
              }
            }
          }
        }
      end

      describe 'create qualified_resource_source' do
        let(:qualified_resource_source) { Integration::Supports::QualifiedResourceSource.last }

        it 'imports data' do
          expect(qualified_resource_source.codigo).to eq('10000')
          expect(qualified_resource_source.titulo).to eq('TESOURO, RECURSOS ORDINÁRIOS')
        end
      end
    end

    describe 'legal_device' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_dispositivo_legal: {
                dispositivo_legal: [
                  {:codigo=>"01", :descricao=>"Art 25, inciso I - Para a aquisicao de materiais, equipamentos ou generos que so possam ser fornecidos por produtor exclusivo..."}
                ]
              }
            }
          }
        }
      end

      describe 'create legal_device' do
        let(:legal_device) { Integration::Supports::LegalDevice.last }

        it 'imports data' do
          expect(legal_device.codigo).to eq('01')
          expect(legal_device.descricao).to eq('Art 25, inciso I - Para a aquisicao de materiais, equipamentos ou generos que so possam ser fornecidos por produtor exclusivo...')
        end
      end
    end

    describe 'economic_category' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_categoria_economica: {
                categoria_economica: [
                  {:codigo_categoria_economica=>"3", :titulo=>"DESPESA CORRENTE"}
                ]
              }
            }
          }
        }
      end

      describe 'create economic_category' do
        let(:economic_category) { Integration::Supports::EconomicCategory.last }

        it 'imports data' do
          expect(economic_category.codigo_categoria_economica).to eq('3')
          expect(economic_category.titulo).to eq('DESPESA CORRENTE')
        end
      end
    end

    describe 'expense_element' do
      let(:body) do
        {
          consulta_tabela_exercicio_response: {
            tabela_exercicio: {
              lista_elemento_despesa: {
                elemento_despesa: [
                  {:codigo_elemento_despesa=>"00",
                    :eh_elementar=>false,
                    :eh_licitacao=>false,
                    :eh_transferencia=>false,
                    :titulo=>"APLICAÇÕES DIRETAS"}
                ]
              }
            }
          }
        }
      end

      describe 'create expense_element' do
        let(:expense_element) { Integration::Supports::ExpenseElement.last }

        it 'imports data' do
          expect(expense_element.codigo_elemento_despesa).to eq('00')
          expect(expense_element.eh_elementar).to eq(false)
          expect(expense_element.eh_licitacao).to eq(false)
          expect(expense_element.eh_transferencia).to eq(false)
          expect(expense_element.titulo).to eq('APLICAÇÕES DIRETAS')
        end
      end
    end
  end
end
