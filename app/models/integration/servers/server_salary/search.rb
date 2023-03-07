#
# Métodos e constantes de busca para Integration::Servers::ServerSalary
#

module Integration::Servers::ServerSalary::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = {
    registration: [
      :server,
      :organ
    ],

    role: []
  }

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(integration_servers_server_salaries.server_name)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_supports_organs.codigo_orgao) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_supports_organs.descricao_orgao)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_supports_organs.descricao_entidade)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_server_roles.name)) LIKE unaccent(LOWER(:search))
  }
end
