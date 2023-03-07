#
# Representa um model básico de dados da aplicação `integracao`.
# Eles são interoperáveis com os models da camada de integração
#
class ApplicationEtlIntegrationRecord < ApplicationRecord

  before_save :exception_change_another_database, unless: :is_env_test?
  before_destroy :exception_change_another_database, unless: :is_env_test?

  FROM_TO = {}

  self.abstract_class = true
  establish_connection ETL_INTEGRATION_DATABASE_CONFIG

  def self.from_to
    self::FROM_TO
  end

  def self.delete_all
    raise 'cant change data from another database'
  end

  def exception_change_another_database
    raise 'cant change data from another database'
  end

  def is_env_test?
    Rails.env.test?
  end

  
end