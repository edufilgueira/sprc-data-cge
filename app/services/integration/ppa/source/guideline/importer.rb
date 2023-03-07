#
# Importador de EixosTema do PPA
#
class Integration::PPA::Source::Guideline::Importer < Integration::PPA::Source::BaseImporter

  #
  # XXX Essa é a definição atual do webservice consumiro pelo PPA::Source::Guideline::Importer
  # @see https://github.com/caiena/sprc/issues/641
  # Resumindo:
  # - o parâmetro ano usado para consumo do webservice é persistido em Guideline#ano
  # - se Guideline#ano == 2017, então os dados do Guideline são relativos ao biênio [2016, 2017]
  # - se Guideline#ano == 2018, então os dados do Guideline são relativos ao biênio [2018, 2019]
  #
  AVAILABLE_YEARS = [2017, 2018].freeze


  private

  def importer_id
    :ppa_source_guideline
  end

  def configuration_class
    Integration::PPA::Source::Guideline::Configuration
  end

  def resource_class
    ::PPA::Source::Guideline
  end

  def resource_finder_params(attributes)
    attributes.slice *%i[
      ano
      codigo_regiao
      codigo_eixo
      codigo_tema
      codigo_ppa_objetivo_estrategico
      codigo_ppa_estrategia
      codigo_programa
      codigo_ppa_iniciativa
      codigo_acao
      codigo_produto
      descricao_referencia
    ]
  end

  def import_resource(attributes, line)
    #
    # *** OVERRIDING ***
    # Atribuindo o ano do parâmetro do importador
    # Não temos o atributo 'ano' na resposta do WS
    #
    # XXX Essa é a definição atual do webservice consumiro pelo PPA::Source::Guideline::Importer
    # @see https://github.com/caiena/sprc/issues/641
    # Resumindo:
    # - o parâmetro ano usado para consumo do webservice é persistido em Guideline#ano
    # - se Guideline#ano == 2017, então os dados do Guideline são relativos ao biênio [2016, 2017]
    # - se Guideline#ano == 2018, então os dados do Guideline são relativos ao biênio [2018, 2019]
    #
    #
    attributes[:ano] = @configuration.year

    # XXX Ao invés de seguir o padrão e criar campos _ano1,2,3,4, a SEPLAG criou os novos
    # campos de valores orçamentários com sufixo _2016,2017,2018,2019!
    #
    #  Vamos padronizar o sufixo aqui, usando _ano1,2,3,4
    attributes[:valor_lei_ano1]          = attributes[:valor_lei2016]
    attributes[:valor_lei_ano2]          = attributes[:valor_lei2017]
    attributes[:valor_lei_ano3]          = attributes[:valor_lei2018]
    attributes[:valor_lei_ano4]          = attributes[:valor_lei2019]
    attributes[:valor_lei_creditos_ano1] = attributes[:valor_lei_creditos2016]
    attributes[:valor_lei_creditos_ano2] = attributes[:valor_lei_creditos2017]
    attributes[:valor_lei_creditos_ano3] = attributes[:valor_lei_creditos2018]
    attributes[:valor_lei_creditos_ano4] = attributes[:valor_lei_creditos2019]
    attributes[:valor_empenhado_ano1]    = attributes[:valor_empenhado2016]
    attributes[:valor_empenhado_ano2]    = attributes[:valor_empenhado2017]
    attributes[:valor_empenhado_ano3]    = attributes[:valor_empenhado2018]
    attributes[:valor_empenhado_ano4]    = attributes[:valor_empenhado2019]
    attributes[:valor_pago_ano1]         = attributes[:valor_pago2016]
    attributes[:valor_pago_ano2]         = attributes[:valor_pago2017]
    attributes[:valor_pago_ano3]         = attributes[:valor_pago2018]
    attributes[:valor_pago_ano4]         = attributes[:valor_pago2019]

    super
  end

  def message
    #
    # *** OVERRIDING ***
    # O acesso ao serviço requer o parâmetro 'ano' presente e
    # a 'regiao' ao menos blank
    #
    {
      usuario: @configuration.user,
      senha: @configuration.password,
      ano: @configuration.year,
      regiao: @configuration.region
    }
  end
end
