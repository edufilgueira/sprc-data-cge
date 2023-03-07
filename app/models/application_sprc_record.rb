#
# Representa um model básico de dados da aplicação `sprc`.
# Eles são interoperáveis com os models da camada de integração - `sprc-data`.
#
class ApplicationSprcRecord < ApplicationRecord
  self.abstract_class = true
  establish_connection SPRC_DATABASE_CONFIG

end
