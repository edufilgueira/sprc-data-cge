class Integration::Supports::Theme < ApplicationRecord

  validates :codigo_tema,
    :descricao_tema,
    presence: true

  def title
    descricao_tema
  end
end
