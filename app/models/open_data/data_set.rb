#
# Representa um conjunto de Dados Abertos
#

class OpenData::DataSet < ApplicationDataRecord

  # Associations

  belongs_to :organ, class_name: 'Integration::Supports::Organ'

  has_many :data_items, foreign_key: :open_data_data_set_id, dependent: :destroy
  has_many :data_set_vcge_categories, foreign_key: :open_data_data_set_id, dependent: :destroy

  #  Validations

  ## Presence

  validates :title,
    :organ,
    presence: true

end
