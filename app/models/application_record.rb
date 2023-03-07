#
# Representa o model básico da aplicação. Todos os models herdam de
# ApplicationRecord.
#

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

end
