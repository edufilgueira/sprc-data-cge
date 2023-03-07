class Integration::Macroregions::MacroregionInvestiment < ApplicationRecord

  # Associations

  belongs_to :power, class_name: 'Integration::Macroregions::Power'
  belongs_to :region, class_name: 'Integration::Macroregions::Region'

  # Validations

  validates :ano_exercicio,
    :codigo_poder,
    :codigo_regiao,
    presence: true

  validates :ano_exercicio,
    uniqueness: { scope: [:codigo_poder, :codigo_regiao] }

  # Callbacks

  after_validation :set_perc_pago_calculated


  # Class methods

  ## Scopes

  def self.active_on_month(date)
    where(ano_exercicio: date.year.to_s)
  end


  # privates

  private

  def set_perc_pago_calculated
    self.perc_pago_calculated = (valor_pago / valor_lei) * 100
  end
end
