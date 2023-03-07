namespace :open_data do
  namespace :vcge_categories do
    task create_or_update: :environment do

      def import_category(parent, vcge_category)
        data = vcge_category[:data]

        if data.is_a?(Hash)
          vcge_id = vcge_category[:attr][:id]
          href = data[:href]
          name = data[:name]
          title = data[:title]
        else
          vcge_id = vcge_category[:attr][:id]
          href = vcge_category[:attr][:href]
          name = vcge_category[:attr][:name]
          title = data
        end

        category = OpenData::VcgeCategory.find_or_initialize_by(vcge_id: vcge_id)
        category.href = href
        category.name = name
        category.title = title

        category.save!

        if parent.present?
          unless parent.children.map(&:vcge_id).include?(vcge_id)
            parent.children << category
          end
        end

        children = vcge_category[:children] || []

        children.each do |child_category|
          import_category(category, child_category)
        end
      end

      vcge_categories = [
        {
          data: {
            href: "#administracao",
            name: "administracao",
            title: "Administração"
          },
          attr: {
            id: "administracao"
          },
          children: [
            {
              data: "Compras governamentais",
              attr: {
                href: "#compras-governamentais",
                id: "compras-governamentais",
                name: "compras-governamentais"
              }
            },
            {
              data: "Fiscalização do Estado",
              attr: {
                href: "#fiscalizacao-estado",
                id: "fiscalizacao-estado",
                name: "fiscalizacao-estado"
              }
            },
            {
              data: "Normalização e Qualidade",
              attr: {
                href: "#normalizacao-qualidade",
                id: "normalizacao-qualidade",
                name: "normalizacao-qualidade"
              }
            },
            {
              data: "Operações de dívida pública",
              attr: {
                href: "#operacoes-divida-publica",
                id: "operacoes-divida-publica",
                name: "operacoes-divida-publica"
              }
            },
            {
              data: "Orçamento",
              attr: {
                href: "#orcamento",
                id: "orcamento",
                name: "orcamento"
              }
            },
            {
              data: "Outros em Administração",
              attr: {
                href: "#outros-administracao",
                id: "outros-administracao",
                name: "outros-administracao"
              }
            },
            {
              data: "Patrimônio",
              attr: {
                href: "#patrimonio",
                id: "patrimonio",
                name: "patrimonio"
              }
            },
            {
              data: "Planejamento ",
              attr: {
                href: "#planejamento",
                id: "planejamento",
                name: "planejamento"
              }
            },
            {
              data: "Recursos humanos",
              attr: {
                href: "#recursos-humanos",
                id: "recursos-humanos",
                name: "recursos-humanos"
              }
            },
            {
              data: "Serviços Públicos ",
              attr: {
                href: "#servicos-publicos",
                id: "servicos-publicos",
                name: "servicos-publicos"
              }
            }
          ]
        },

        {
          data: {
            href: "#agropecuaria",
            name: "agropecuaria",
            title: "Agropecuária"
          },
          attr: {
            id: "agropecuaria"
          },
          children: [
            {
              data: "Abastecimento",
              attr: {
                href: "#abastecimento",
                id: "abastecimento",
                name: "abastecimento"
              }
            },
            {
              data: "Defesa agropecuária",
              attr: {
                href: "#defesa-agropecuaria",
                id: "defesa-agropecuaria",
                name: "defesa-agropecuaria"
              }
            },
            {
              data: "Outros em Agropecuária",
              attr: {
                href: "#outros-agropecuaria",
                id: "outros-agropecuaria",
                name: "outros-agropecuaria"
              }
            },
            {
              data: "Produção agropecuária",
              attr: {
                href: "#producao-agropecuaria",
                id: "producao-agropecuaria",
                name: "producao-agropecuaria"
              }
            }
          ]
        },
        {
          data: {
            href: "#comercio-servicos",
            name: "comercio-servicos",
            title: "Comércio e Serviços"
          },
          attr: {
            id: "comercio-servicos"
          },
          children: [
            {
              data: "Comercio externo",
              attr: {
                href: "#comercio-externo",
                id: "comercio-externo",
                name: "comercio-externo"
              }
            },
            {
              data: "Defesa do Consumidor",
              attr: {
                href: "#defesa-consumidor",
                id: "defesa-consumidor",
                name: "defesa-consumidor"
              }
            },
            {
              data: "Outros em Comércio e serviços",
              attr: {
                href: "#outros-comercio-servicos",
                id: "outros-comercio-servicos",
                name: "outros-comercio-servicos"
              }
            },
            {
              data: "Turismo ",
              attr: {
                href: "#turismo",
                id: "turismo",
                name: "turismo"
              }
            }
          ]
        },
        {
          data: {
            href: "#comunicacoes",
            name: "comunicacoes",
            title: "Comunicações"
          },
          attr: {
            id: "comunicacoes"
          },
          children: [
            {
              data: "Comunicações Postais",
              attr: {
                href: "#comunicacoes-postais",
                id: "comunicacoes-postais",
                name: "comunicacoes-postais"
              }
            },
            {
              data: "Outros em Comunicações",
              attr: {
                href: "#outros-comunicacoes",
                id: "outros-comunicacoes",
                name: "outros-comunicacoes"
              }
            },
            {
              data: "Telecomunicações",
              attr: {
                href: "#telecomunicacoes",
                id: "telecomunicacoes",
                name: "telecomunicacoes"
              }
            }
          ]
        },
        {
          data: {
            href: "#cultura",
            name: "cultura",
            title: "Cultura"
          },
          attr: {
            id: "cultura"
          },
          children: [
            {
              data: "Difusão Cultural ",
              attr: {
                href: "#difusao-cultural",
                id: "difusao-cultural",
                name: "difusao-cultural"
              }
            },
            {
              data: "Outros em Cultura",
              attr: {
                href: "#outros-cultura",
                id: "outros-cultura",
                name: "outros-cultura"
              }
            },
            {
              data: "Patrimônio Cultural ",
              attr: {
                href: "#patrimonio-cultural",
                id: "patrimonio-cultural",
                name: "patrimonio-cultural"
              }
            }
          ]
        },
        {
          data: {
            href: "#defesa-nacional",
            name: "defesa-nacional",
            title: "Defesa Nacional"
          },
          attr: {
            id: "defesa-nacional"
          },
          children: [
            {
              data: "Defesa Civil",
              attr: {
                href: "#defesa-civil",
                id: "defesa-civil",
                name: "defesa-civil"
              }
            },
            {
              data: "Defesa militar",
              attr: {
                href: "#defesa-militar",
                id: "defesa-militar",
                name: "defesa-militar"
              }
            },
            {
              data: "Outros em Defesa Nacional",
              attr: {
                href: "#outros-defesa-nacional",
                id: "outros-defesa-nacional",
                name: "outros-defesa-nacional"
              }
            }
          ]
        },
        {
          data: {
            href: "#economia-financas",
            name: "economia-financas",
            title: "Economia e Finanças"
          },
          attr: {
            id: "economia-financas"
          },
          children: [
            {
              data: "Outros em Economia e Finanças",
              attr: {
                href: "#outros-economia-financas",
                id: "outros-economia-financas",
                name: "outros-economia-financas"
              }
            },
            {
              data: "Politica econômica",
              attr: {
                href: "#politica-economica",
                id: "politica-economica",
                name: "politica-economica"
              }
            },
            {
              data: "Sistema Financeiro ",
              attr: {
                href: "#sistema-financeiro",
                id: "sistema-financeiro",
                name: "sistema-financeiro"
              }
            }
          ]
        },
        {
          data: {
            href: "#educacao",
            name: "educacao",
            title: "Educação "
          },
          attr: {
            id: "educacao"
          },
          children: [
            {
              data: "Educação básica",
              attr: {
                href: "#educacao-basica",
                id: "educacao-basica",
                name: "educacao-basica"
              }
            },
            {
              data: "Educação profissionalizante ",
              attr: {
                href: "#educacao-profissionalizante",
                id: "educacao-profissionalizante",
                name: "educacao-profissionalizante"
              }
            },
            {
              data: "Educação superior ",
              attr: {
                href: "#educacao-superior",
                id: "educacao-superior",
                name: "educacao-superior"
              }
            },
            {
              data: "Outros em Educação",
              attr: {
                href: "#outros-educacao",
                id: "outros-educacao",
                name: "outros-educacao"
              }
            }
          ]
        },
        {
          data: {
            href: "#energia",
            name: "energia",
            title: "Energia"
          },
          attr: {
            id: "energia"
          },
          children: [
            {
              data: "Combustíveis",
              attr: {
                href: "#combustiveis",
                id: "combustiveis",
                name: "combustiveis"
              }
            },
            {
              data: "Energia elétrica",
              attr: {
                href: "#energia-eletrica",
                id: "energia-eletrica",
                name: "energia-eletrica"
              }
            },
            {
              data: "Outros em Energia",
              attr: {
                href: "#outros-energia",
                id: "outros-energia",
                name: "outros-energia"
              }
            }
          ]
        },
        {
          data: {
            href: "#esporte-lazer",
            name: "esporte-lazer",
            title: "Esporte e Lazer"
          },
          attr: {
            id: "esporte-lazer"
          },
          children: [
            {
              data: "Esporte comunitário",
              attr: {
                href: "#esporte-comunitario",
                id: "esporte-comunitario",
                name: "esporte-comunitario"
              }
            },
            {
              data: "Esporte profissional",
              attr: {
                href: "#esporte-profissional",
                id: "esporte-profissional",
                name: "esporte-profissional"
              }
            },
            {
              data: "Lazer",
              attr: {
                href: "#lazer",
                id: "lazer",
                name: "lazer"
              }
            },
            {
              data: "Outros em Esporte e Lazer",
              attr: {
                href: "#outros-esporte-lazer",
                id: "outros-esporte-lazer",
                name: "outros-esporte-lazer"
              }
            }
          ]
        },
        {
          data: {
            href: "#habitacao",
            name: "habitacao",
            title: "Habitação"
          },
          attr: {
            id: "habitacao"
          },
          children: [
            {
              data: "Habitação Rural",
              attr: {
                href: "#habitacao-rural",
                id: "habitacao-rural",
                name: "habitacao-rural"
              }
            },
            {
              data: "Habitação Urbana",
              attr: {
                href: "#habitacao-urbana",
                id: "habitacao-urbana",
                name: "habitacao-urbana"
              }
            },
            {
              data: "Outros em Habitação",
              attr: {
                href: "#outros-habitacao",
                id: "outros-habitacao",
                name: "outros-habitacao"
              }
            }
          ]
        },
        {
          data: {
            href: "#industria",
            name: "industria",
            title: "Indústria"
          },
          attr: {
            id: "industria"
          },
          children: [
            {
              data: "Mineração",
              attr: {
                href: "#mineracao",
                id: "mineracao",
                name: "mineracao"
              }
            },
            {
              data: "Outros em Industria",
              attr: {
                href: "#outros-industria",
                id: "outros-industria",
                name: "outros-industria"
              }
            },
            {
              data: "Produção Industrial",
              attr: {
                href: "#producao-industrial",
                id: "producao-industrial",
                name: "producao-industrial"
              }
            },
            {
              data: "Propriedade Industrial",
              attr: {
                href: "#propriedade-industrial",
                id: "propriedade-industrial",
                name: "propriedade-industrial"
              }
            }
          ]
        },
        {
          data: {
            href: "#meio-ambiente",
            name: "meio-ambiente",
            title: "Meio ambiente "
          },
          attr: {
            id: "meio-ambiente"
          },
          children: [
            {
              data: "Água",
              attr: {
                href: "#agua",
                id: "agua",
                name: "agua"
              }
            },
            {
              data: "Biodiversidade",
              attr: {
                href: "#biodiversidade",
                id: "biodiversidade",
                name: "biodiversidade"
              }
            },
            {
              data: "Clima",
              attr: {
                href: "#clima",
                id: "clima",
                name: "clima"
              }
            },
            {
              data: "Outros em Meio Ambiente",
              attr: {
                href: "#outros-meio-ambiente",
                id: "outros-meio-ambiente",
                name: "outros-meio-ambiente"
              }
            },
            {
              data: "Preservação e Conservação Ambiental",
              attr: {
                href: "#preservacao-conservacao-ambiental",
                id: "preservacao-conservacao-ambiental",
                name: "preservacao-conservacao-ambiental"
              }
            }
          ]
        },
        {
          data: {
            href: "#pesquisa-desenvolvimento",
            name: "pesquisa-desenvolvimento",
            title: "Pesquisa e Desenvolvimento"
          },
          attr: {
            id: "pesquisa-desenvolvimento"
          },
          children: [
            {
              data: "Difusão",
              attr: {
                href: "#difusao",
                id: "difusao",
                name: "difusao"
              }
            },
            {
              data: "Outros em Pesquisa e Desenvolvimento",
              attr: {
                href: "#outros-pesquisa-desenvolvimento",
                id: "outros-pesquisa-desenvolvimento",
                name: "outros-pesquisa-desenvolvimento"
              }
            }
          ]
        },
        {
          data: {
            href: "#previdencia-social",
            name: "previdencia-social",
            title: "Previdência Social"
          },
          attr: {
            id: "previdencia-social"
          },
          children: [
            {
              data: "Outros em Previdência",
              attr: {
                href: "#outros-previdencia",
                id: "outros-previdencia",
                name: "outros-previdencia"
              }
            },
            {
              data: "Previdência Básica",
              attr: {
                href: "#previdencia-basica",
                id: "previdencia-basica",
                name: "previdencia-basica"
              }
            },
            {
              data: "Previdência Complementar",
              attr: {
                href: "#previdencia-complementar",
                id: "previdencia-complementar",
                name: "previdencia-complementar"
              }
            }
          ]
        },
        {
          data: {
            href: "#protecao-social",
            name: "protecao-social",
            title: "Proteção Social"
          },
          attr: {
            id: "protecao-social"
          },
          children: [
            {
              data: "Assistência à Criança e ao Adolescente",
              attr: {
                href: "#assistencia-crianca-adolescente",
                id: "assistencia-crianca-adolescente",
                name: "assistencia-crianca-adolescente"
              }
            },
            {
              data: "Assistência ao Idoso",
              attr: {
                href: "#assistencia-idoso",
                id: "assistencia-idoso",
                name: "assistencia-idoso"
              }
            },
            {
              data: "Assistência ao Portador de Deficiência",
              attr: {
                href: "#assistencia-portador-deficiencia",
                id: "assistencia-portador-deficiencia",
                name: "assistencia-portador-deficiencia"
              }
            },
            {
              data: "Cidadania",
              attr: {
                href: "#cidadania",
                id: "cidadania",
                name: "cidadania"
              }
            },
            {
              data: "Combate a desigualdade",
              attr: {
                href: "#combate-desigualdade",
                id: "combate-desigualdade",
                name: "combate-desigualdade"
              }
            },
            {
              data: "Outros em Proteção Social",
              attr: {
                href: "#outros-protecao-social",
                id: "outros-protecao-social",
                name: "outros-protecao-social"
              }
            }
          ]
        },
        {
          data: {
            href: "#relacoes-internacionais",
            name: "relacoes-internacionais",
            title: "Relações Internacionais"
          },
          attr: {
            id: "relacoes-internacionais"
          },
          children: [
            {
              data: "Cooperação Internacional",
              attr: {
                href: "#cooperacao-internacional",
                id: "cooperacao-internacional",
                name: "cooperacao-internacional"
              }
            },
            {
              data: "Outros em Relações Internacionais",
              attr: {
                href: "#outros-relacoes-internacionais",
                id: "outros-relacoes-internacionais",
                name: "outros-relacoes-internacionais"
              }
            },
            {
              data: "Relações Diplomáticas",
              attr: {
                href: "#relacoes-diplomaticas",
                id: "relacoes-diplomaticas",
                name: "relacoes-diplomaticas"
              }
            }
          ]
        },
        {
          data: {
            href: "#saneamento",
            name: "saneamento",
            title: "Saneamento"
          },
          attr: {
            id: "saneamento"
          },
          children: [
            {
              data: "Outros em Saneamento",
              attr: {
                href: "#outros-saneamento",
                id: "outros-saneamento",
                name: "outros-saneamento"
              }
            },
            {
              data: "Saneamento Básico Rural",
              attr: {
                href: "#saneamento-basico-rural",
                id: "saneamento-basico-rural",
                name: "saneamento-basico-rural"
              }
            },
            {
              data: "Saneamento Básico Urbano",
              attr: {
                href: "#saneamento-basico-urbano",
                id: "saneamento-basico-urbano",
                name: "saneamento-basico-urbano"
              }
            }
          ]
        },
        {
          data: {
            href: "#saude",
            name: "saude",
            title: "Saúde"
          },
          attr: {
            id: "saude"
          },
          children: [
            {
              data: "Assistência Hospitalar e Ambulatorial",
              attr: {
                href: "#assistencia-hospitalar-ambulatorial",
                id: "assistencia-hospitalar-ambulatorial",
                name: "assistencia-hospitalar-ambulatorial"
              }
            },
            {
              data: "Atendimento básico ",
              attr: {
                href: "#atendimento-basico",
                id: "atendimento-basico",
                name: "atendimento-basico"
              }
            },
            {
              data: "Combate a epidemias",
              attr: {
                href: "#combate-epidemias",
                id: "combate-epidemias",
                name: "combate-epidemias"
              }
            },
            {
              data: "Medicamentos e aparelhos",
              attr: {
                href: "#medicamentos-aparelhos",
                id: "medicamentos-aparelhos",
                name: "medicamentos-aparelhos"
              }
            },
            {
              data: "Outros em Saúde",
              attr: {
                href: "#outros-saude",
                id: "outros-saude",
                name: "outros-saude"
              }
            },
            {
              data: "Vigilância Sanitária",
              attr: {
                href: "#vigilancia-sanitaria",
                id: "vigilancia-sanitaria",
                name: "vigilancia-sanitaria"
              }
            }
          ]
        },
        {
          data: {
            href: "#seguranca-ordem-publica",
            name: "seguranca-ordem-publica",
            title: "Segurança e Ordem Pública"
          },
          attr: {
            id: "seguranca-ordem-publica"
          },
          children: [
            {
              data: "Defesa Civil",
              attr: {
                href: "#defesa-civil",
                id: "defesa-civil",
                name: "defesa-civil"
              }
            },
            {
              data: "Outros em Segurança e Ordem Pública",
              attr: {
                href: "#outros-seguranca-ordem-publica",
                id: "outros-seguranca-ordem-publica",
                name: "outros-seguranca-ordem-publica"
              }
            },
            {
              data: "Policiamento",
              attr: {
                href: "#policiamento",
                id: "policiamento",
                name: "policiamento"
              }
            }
          ]
        },
        {
          data: {
            href: "#trabalho",
            name: "trabalho",
            title: "Trabalho "
          },
          attr: {
            id: "trabalho"
          },
          children: [
            {
              data: "Empregabilidade",
              attr: {
                href: "#empregabilidade",
                id: "empregabilidade",
                name: "empregabilidade"
              }
            },
            {
              data: "Fomento ao Trabalho",
              attr: {
                href: "#fomento-trabalho",
                id: "fomento-trabalho",
                name: "fomento-trabalho"
              }
            },
            {
              data: "Outros em Trabalho",
              attr: {
                href: "#outros-trabalho",
                id: "outros-trabalho",
                name: "outros-trabalho"
              }
            },
            {
              data: "Proteção e Benefícios ao Trabalhador",
              attr: {
                href: "#protecao-beneficios-trabalhador",
                id: "protecao-beneficios-trabalhador",
                name: "protecao-beneficios-trabalhador"
              }
            },
            {
              data: "Relações de Trabalho",
              attr: {
                href: "#relacoes-trabalho",
                id: "relacoes-trabalho",
                name: "relacoes-trabalho"
              }
            }
          ]
        },
        {
          data: {
            href: "#transportes",
            name: "transportes",
            title: "Transportes"
          },
          attr: {
            id: "transportes"
          },
          children: [
            {
              data: "Outros em Transporte",
              attr: {
                href: "#outros-transporte",
                id: "outros-transporte",
                name: "outros-transporte"
              }
            },
            {
              data: "Transporte Aéreo",
              attr: {
                href: "#transporte-aereo",
                id: "transporte-aereo",
                name: "transporte-aereo"
              }
            },
            {
              data: "Transporte Ferroviário",
              attr: {
                href: "#transporte-ferroviario",
                id: "transporte-ferroviario",
                name: "transporte-ferroviario"
              }
            },
            {
              data: "Transporte Hidroviário",
              attr: {
                href: "#transporte-hidroviario",
                id: "transporte-hidroviario",
                name: "transporte-hidroviario"
              }
            },
            {
              data: "Transporte Rodoviário",
              attr: {
                href: "#transporte-rodoviario",
                id: "transporte-rodoviario",
                name: "transporte-rodoviario"
              }
            }
          ]
        },
        {
          data: {
            href: "#urbanismo",
            name: "urbanismo",
            title: "Urbanismo "
          },
          attr: {
            id: "urbanismo"
          },
          children: [
            {
              data: "Infraestrutura Urbana",
              attr: {
                href: "#infraestrutura-urbana",
                id: "infraestrutura-urbana",
                name: "infraestrutura-urbana"
              }
            },
            {
              data: "Outros em Urbanismo",
              attr: {
                href: "#outros-urbanismo",
                id: "outros-urbanismo",
                name: "outros-urbanismo"
              }
            },
            {
              data: "Serviços Urbanos",
              attr: {
                href: "#servicos-urbanos",
                id: "servicos-urbanos",
                name: "servicos-urbanos"
              }
            }
          ]
        }
      ]

      vcge_categories.each do |vcge_category|
        import_category(nil, vcge_category)
      end

    end
  end
end
