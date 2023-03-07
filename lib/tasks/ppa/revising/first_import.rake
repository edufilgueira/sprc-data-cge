# Importa dados para SPRC

namespace :ppa do
  namespace :revising do
    task :first_import => :environment do

      ActiveRecord::Base.transaction do
        total = Integration::PPA::Source::AxisThemeObjectiveStrategy.count
        Integration::PPA::Source::AxisThemeObjectiveStrategy.find_each.with_index do |row, index|
          plan = PPA::Plan.find_by_start_year(row.ppa_ano_inicio)

          axis = SupportRevisingPPA.find_or_create_axis(row, plan)

          region = SupportRevisingPPA.find_or_create_region(row)

          theme = SupportRevisingPPA.find_or_create_theme(row, axis)

          objective = SupportRevisingPPA.find_or_create_objective(row, region)

          strategy = SupportRevisingPPA.find_or_create_strategy(row, objective)

          theme_strategy = PPA::ThemeStrategy.find_or_create_by(theme_id: theme.id, strategy_id: strategy.id)

          ap "#{index + 1} / #{total}"
        end

        ap "Desabilitando temas sem isn..."
        PPA::Theme.where(isn: nil, disabled_at: nil).update_all(disabled_at: DateTime.now)
        ap "Desabilitando objetivos sem isn..."
        PPA::Objective.where(isn: nil, disabled_at: nil).update_all(disabled_at: DateTime.now)
        ap "Desabilitando estratégias sem isn..."
        PPA::Strategy.where(isn: nil, disabled_at: nil).update_all(disabled_at: DateTime.now)
      end
    end
  end
end

class SupportRevisingPPA
  def self.find_or_create_strategy(row, objective)
    strategy = PPA::Strategy.find_by(code: row.estrategia_cod)

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
      strategy.save
    end

    strategy
  end

  def self.find_or_create_objective(row, region)
    objective = PPA::Objective.find_by(code: row.objetivo_cod)

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
      objective.region_id = region.id
      objective.save
    end

    objective
  end

  def self.find_or_create_region(row)
    region = PPA::Region.find_by(code: row.regiao_cod)

    if region.blank?
      region = PPA::Region.create(
        code: row.regiao_cod,
        name: row.regiao_descricao,
        isn: row.regiao_isn
      )
    else
      region.name = row.regiao_descricao
      region.isn = row.regiao_isn
      region.save
    end

    region
  end

  def self.find_or_create_axis(row, plan)
    axis = PPA::Axis.find_by(code: row.eixo_cod, plan_id: plan.id)

    if axis.blank?
      axis = plan.axes.create(
        code: row.eixo_cod,
        name: row.eixo_descricao,
        isn: row.eixo_isn
      )
    else
      axis.name = row.eixo_descricao
      axis.isn = row.eixo_isn
      axis.save
    end

    axis
  end

  def self.find_or_create_theme(row, axis)
    theme = PPA::Theme.find_by(code: row.tema_cod, axis_id: axis.id)

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
      theme.save
    end

    theme
  end
end
