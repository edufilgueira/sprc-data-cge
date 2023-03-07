#
# Representa as exportações das listas filtradas das consultas de transparência
#
class Transparency::Export < ApplicationRecord

  # enums

  enum status: [:queued, :in_progress, :error, :success]
  enum worksheet_format: [:xlsx, :csv]

  # validations

  validates :name,
    :email,
    :query,
    :worksheet_format,
    :resource_name,
    presence: true

end
