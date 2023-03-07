class Integration::Supports::Axis < ApplicationRecord

  validates :codigo_eixo,
    :descricao_eixo,
    presence: true

  def title
    descricao_eixo
  end
end
