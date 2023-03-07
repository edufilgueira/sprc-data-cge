#
# Representa a entidade de integração de Obras DAE
#
# Extende a classe (Integration::BaseDataChange) que registra as atualizações de atributos notificáveis ao cidadão
#
class Integration::Constructions::Dae < Integration::BaseDataChange

  # Consts

  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :status,
    :valor,
    :data_fim_previsto,
    :prazo_inicial,
    :percentual_executado,
    :dias_aditivado,
    # Planilha de medição - callback em Constructions::Dae::Measurement
    # Fotos da Obra - callback em Constructions::Dae::Photo
  ]


  # Associations

  belongs_to :organ, class_name: 'Integration::Supports::Organ'


  # Enums

  enum dae_status: [
    :waiting,
    :canceled,
    :done,
    :in_progress,
    :finished,
    :paused
  ]

  # Validations

  ## Presence

  validates :id_obra,
    :descricao,
    presence: true

  has_many :measurements,
  class_name: 'Integration::Constructions::Dae::Measurement',
  foreign_key: 'integration_constructions_dae_id',
  dependent: :destroy

  has_many :photos,
  class_name: 'Integration::Constructions::Dae::Photo',
  foreign_key: 'integration_constructions_dae_id',
  dependent: :destroy



  # Public

  ## Class methods

  ### Scopes

  def self.active_on_month(date)
    end_of_month = date.end_of_month

    # Obras ativas considera período e não considera o status
    where("DATE(data_inicio) <= :end_of_month AND DATE(data_fim_previsto) >= :end_of_month", end_of_month: end_of_month)
  end

  ## Instance methods

  ### Helpers

  def title
    "#{codigo_obra.to_s} - #{descricao.truncate(30)}"
  end
end
