#
# Tabela Base
#
# Região Administrative
#

class EtlIntegration::BudgetBalance < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.saldo_orcamentario"

  FROM_TO = {
    "codug" => "cod_unid_gestora",
    "coduo" => "cod_unid_orcam",
    "codfuncao" => "cod_funcao",
    "codsubfuncao" => "cod_subfuncao",
    "codprograma" => "cod_programa",
    "codacao" => "cod_acao",
    "codlocalizadorgasto" => "cod_localizacao_gasto",
    "codnatureza" => "cod_natureza_desp",
    "codfonte" => "cod_fonte",
    "coddetafonte" => nil,
    "codiduso" => "id_uso",
    "classificacaoacao" => nil,
    "codesfera" => "cod_esfera_orcam",
    "classifreduzida" => "classif_orcam_reduz",
    "classificacaocompleta" => "classif_orcam_completa",
    "valinicial" => "valor_inicial",
    "valsuplementado" => "valor_suplementado",
    "valanulado" => "valor_anulado",
    "valtransferidorecebido" => "valor_transferido_recebido",
    "valtransferidoconcedido" => "valor_transferido_concedido",
    "valcontido" => "valor_contido",
    "valcontidoanulado" => "valor_contido_anulado",
    "valdescentralizado" => "valor_descentralizado",
    "valdescentralizadoanulado" => "valor_descentralizado_anulado",
    "valempenhado" => "valor_empenhado",
    "valempenhadoanulado" => "valor_empenhado_anulado",
    "valliquidado" => "valor_liquidado",
    "valliquidadoanulado" => "valor_liquidado_anulado",
    "valliquidadoretido" => "valor_liquidado_retido",
    "valliquidadoretidoanulado" => "valor_liquidado_retido_anulado",
    "valpago" => "valor_pago",
    "valpagoanulado" => "valor_pago_anulado",
    "ano_mes_competencia" => "ano_mes_competencia"
  }

end
