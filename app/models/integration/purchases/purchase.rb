class Integration::Purchases::Purchase < ApplicationDataRecord

  # Associations

  belongs_to :manager,
    class_name: 'Integration::Supports::ManagementUnit'


  # Validations

  ## Presence

  validates :numero_publicacao,
    :numero_viproc,
    :num_termo_participacao,
    :codigo_item,
    presence: true

  # Callbacks

  after_validation :set_valor_total_calculated


  def self.active_on_month(date)
    beginning_of_month = date.beginning_of_month
    end_of_month = date.end_of_month

    where("DATE(data_publicacao) >= :beginning_of_month AND DATE(data_publicacao) <= :end_of_month", beginning_of_month: beginning_of_month, end_of_month: end_of_month)
  end

  # private

  private

  def set_valor_total_calculated
    self.valor_total_calculated = quantidade_estimada.to_f * valor_unitario.to_f
  end
end
