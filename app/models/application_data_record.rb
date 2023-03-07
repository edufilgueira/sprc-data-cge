#
# Representa o model básico de dados da aplicação. Todos os models relacionados
# à integração de transparência herdam de ApplicationDataRecord.
#
# Nesta aplicação, ApplicationDataRecord e ApplicationRecord conectam-se na
# mesma base de dados. Só é utilizado para evitar que haja divergências entre
# os models que precisam estar na duas aplicações e evitar situações como:
#
#
# No sprc:
#
#   class OpenData::DataItem < ApplicationDataRecord
#     ...
#   end
#
# No sprc-data:
#
#   class OpenData::DataItem < ApplicationRecord
#     ...
#   end
#

class ApplicationDataRecord < ApplicationRecord
  self.abstract_class = true

end
