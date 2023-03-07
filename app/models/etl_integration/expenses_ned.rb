#
# Tabela Base
#
# Empenho
#

class EtlIntegration::ExpensesNed < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.empenho"

  FROM_TO = {
		"codigoug" => "unidade_gestora",
		"codigo" => "numero",
		"dataemissao" => "data_emissao",
		"codclassificacao" => "classificacao_orcamentaria_completo",
		"nomecredor" => "credor",
		"codparcela" => "isn_parcela",
		"observacao" => "especificacao_geral",
		"modalidade" => "natureza",
  }
   
end