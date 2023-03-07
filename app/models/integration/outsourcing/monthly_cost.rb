class Integration::Outsourcing::MonthlyCost < ApplicationRecord

  validates :numerocontrato,
    :competencia,
    :nome,
    :cpf,
    :orgao,
    :categoria,
    :month_import,
    :isn_entidade,
    presence: true




  before_validation do
    self.categoria = self.undefined_category if !self.categoria.present?
  end

  def self.undefined_category
    I18n.t("#{base_locale}.#{__method__}")
  end

  def self.base_locale
    'transparency.outsourcing.monthly_costs'
  end
  private_class_method :base_locale


  def nome_contratante
    Integration::Contracts::Contract.where(isn_sic: numerocontrato)
      .pluck(:descricao_nome_credor).try(:first)
  end

  def total_net_cost
    vlr_custo_total - remuneracao
  end

end
