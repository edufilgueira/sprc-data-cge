class Integration::PPA::Source::AxisThemeObjectiveStrategy::Importer < Integration::Supports::BaseSupportsImporter

  def self.call(configuration_id)
    super
    # system('rake ppa:revising:import')
  end

  private

  def importer_id
    :axis_theme_obejective_strategy
  end

  def configuration_class
    Integration::PPA::Source::AxisThemeObjectiveStrategy::Configuration
  end

  def resource_class
    Integration::PPA::Source::AxisThemeObjectiveStrategy
  end

  def resource_finder_params(attributes)
    {
      ppa_ano_inicio: attributes[:ppa_ano_inicio],
      ppa_ano_fim: attributes[:ppa_ano_fim],
      eixo_cod: attributes[:eixo_cod],
      regiao_cod: attributes[:regiao_cod],
      tema_cod: attributes[:tema_cod],
      objetivo_cod: attributes[:objetivo_cod],
      estrategia_cod: attributes[:estrategia_cod],
      tema_descricao_detalhada: attributes[:tema_descricao_detalhada],
      eixo_isn: attributes[:eixo_isn],
      tema_isn: attributes[:tema_isn],
      regiao_isn: attributes[:regiao_isn],
      estrategia_isn: attributes[:estrategia_isn],
      objetivo_isn: attributes[:objetivo_isn]
    }
  end

  def message
    {
      usuario: @configuration.user,
      senha: @configuration.password,
      ano: @configuration.year
    }
  end

  def resources
    result_array = response_path.inject(body) do |result, key|

      next if result.nil?

      result[key] || {}
    end

    ensure_resource_type(select_by_year(result_array))
  end


  private

  def select_by_year(result)
    result.select!{ |k| k[:ppa_ano_inicio].to_i == @configuration.year }
  end

end
