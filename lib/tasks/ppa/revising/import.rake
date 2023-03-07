# Importa dados para SPRC

namespace :ppa do
  namespace :revising do
    task :import => :environment do

      # Importador já chama em Integration::PPA::Source::AxisThemeObjectiveStrategy::Importer essa função
      ap "Atualizando registros no sprc-data..."
      Integration::PPA::Source::AxisThemeObjectiveStrategy::Importer.call(1)

      ap "Atualizando dados no sprc..."
      ActiveRecord::Base.transaction do
        total = Integration::PPA::Source::AxisThemeObjectiveStrategy.count
        Integration::PPA::Source::AxisThemeObjectiveStrategy.find_each.with_index do |row, index|
          
          unless row[:estrategia_cod].nil?
            plan = PPA::Plan.find_by_start_year(row.ppa_ano_inicio)

            axis = SupportPPA.find_or_create_axis(row, plan)

            region = SupportPPA.find_or_create_region(row)

            theme = SupportPPA.find_or_create_theme(row, axis)

            objective = SupportPPA.find_or_create_objective(row, region)

            if objective.persisted?
              strategy = SupportPPA.find_or_create_strategy(row, objective)
              if strategy.persisted?
                theme_strategy = PPA::ThemeStrategy.find_or_create_by(theme_id: theme.id, strategy_id: strategy.id)
              end
            end
          end

          
          
          ap "#{index + 1} / #{total}"
        end
      end
    end
  end
end

class SupportPPA
  def self.find_or_create_strategy(row, objective)
    strategy = PPA::Strategy.find_by(isn: row.estrategia_isn)

    if strategy.blank?
      strategy = PPA::Strategy.create(
        code: row.estrategia_cod,
        name: row.estrategia_descricao,
        isn: row.estrategia_isn,
        objective_id: objective.id
      )
    else
      strategy.name = row.estrategia_descricao
      strategy.objective_id = objective.id
      strategy.isn = row.estrategia_isn
      strategy.code = row.estrategia_cod

      strategy.save if strategy.changed?
    end

    strategy
  end

  def self.find_or_create_objective(row, region)
    objective = PPA::Objective.find_by(isn: row.objetivo_isn)

    if objective.blank?
      objective = PPA::Objective.create(
        code: row.objetivo_cod,
        name: row.objetivo_descricao,
        isn: row.objetivo_isn,
        region_id: region.id
      )
    else
      objective.name = row.objetivo_descricao
      objective.isn = row.objetivo_isn
      objective.code = row.objetivo_cod
      objective.region_id = region.id

      objective.save if objective.changed?
    end

    objective
  end

  def self.find_or_create_region(row)
    region = PPA::Region.find_by(isn: row.regiao_isn)

    if region.blank?
      region = PPA::Region.create(
        code: row.regiao_cod,
        name: row.regiao_descricao,
        isn: row.regiao_isn
      )
    else
      region.name = row.regiao_descricao
      region.isn = row.regiao_isn
      region.code = row.regiao_cod

      region.save if region.changed?
    end

    region
  end

  def self.find_or_create_axis(row, plan)
    axis = PPA::Axis.find_by(isn: row.eixo_isn)

    if axis.blank?
      axis = plan.axes.create(
        code: row.eixo_cod,
        name: row.eixo_descricao,
        isn: row.eixo_isn
      )
    else
      axis.name = row.eixo_descricao
      axis.isn = row.eixo_isn
      axis.code = row.eixo_cod

      axis.save if axis.changed?
    end

    axis
  end

  def self.find_or_create_theme(row, axis)
    theme = PPA::Theme.find_by(isn: row.tema_isn)

    if theme.blank?
      theme = axis.themes.create(
        code: row.tema_cod,
        name: row.tema_descricao,
        description: row.tema_descricao_detalhada,
        isn: row.tema_isn
      )
    else
      theme.name = row.tema_descricao
      theme.isn = row.tema_isn
      theme.description = row.tema_descricao_detalhada
      theme.code = row.tema_cod

      theme.save if theme.changed?
    end

    theme
  end
end
