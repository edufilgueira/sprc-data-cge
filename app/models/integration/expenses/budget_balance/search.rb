#
# Métodos e constantes de busca para Integration::Expenses::BudgetBalance
#

module Integration::Expenses::BudgetBalance::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_management_units.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_budget_units.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_functions.descricao) LIKE LOWER(:search) OR
    LOWER(integration_supports_sub_functions.descricao) LIKE LOWER(:search) OR
    LOWER(integration_supports_government_programs.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_government_actions.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_administrative_regions.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_expense_natures.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_qualified_resource_sources.titulo) LIKE LOWER(:search) OR
    LOWER(integration_supports_finance_groups.titulo) LIKE LOWER(:search)
  }
end
