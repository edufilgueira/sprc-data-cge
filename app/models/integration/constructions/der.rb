#
# Representa a entidade de integração de Obras DER
#
# Extende a classe (Integration::BaseDataChange) que registra as atualizações de atributos notificáveis ao cidadão
#
class Integration::Constructions::Der < Integration::BaseDataChange

  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :status,
    :valor_atual,
    :data_fim_previsto,
    :dias_adicionado,
    :dias_suspenso,
    :percentual_executado,
    :conclusao
    # Planilha de medição - callback em Constructions::Der::Measurement
  ]

  # Enums

  enum der_status: [
    :canceled,
    :done,
    :in_progress,
    :in_project,
    :in_bidding,
    :not_started,
    :paused,
    :project_done,
    :bid
  ]

  # Validations

  ## Presence

  validates :id_obra,
    :servicos,
    presence: true

  has_many :measurements,
  class_name: 'Integration::Constructions::Der::Measurement',
  foreign_key: 'integration_constructions_der_id',
  dependent: :destroy

  # Public

  ## Class methods

  ### Scopes

  def self.active_on_month(date)
    end_of_month = date.end_of_month

    where("DATE(data_fim_previsto) >= :end_of_month", end_of_month: end_of_month)
  end


  ## Instance methods

  ### Helpers

  def title
    "#{id_obra.to_s} - #{servicos.truncate(30)}"
  end


end
