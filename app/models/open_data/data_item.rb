#
# Representa um item (arquivo ou webservice) de Dados Abertos
#

class OpenData::DataItem < ApplicationDataRecord

  # Setup

  attachment :document

  # Associations

  belongs_to :data_set, foreign_key: :open_data_data_set_id, class_name: 'OpenData::DataSet'

  # Enums

  enum data_item_type: [:file, :webservice]

  enum status: [:status_queued, :status_in_progress, :status_success, :status_fail]

  #  Validations

  ## Presence

  validates :title,
    :description,
    :data_item_type,
    :data_set,
    :document_public_filename,
    presence: true

  validates :document,
    presence: true,
    if: :file?

  validates :status,
    :response_path,
    :wsdl,
    :operation,
    presence: true,
    if: :webservice?


  def import
    status_queued!

    OpenData::Importer.delay.call(id)
  end
end
