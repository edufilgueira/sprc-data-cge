class Integration::Contracts::Additive < Integration::BaseDataChange
  include Integration::Contracts::SubResource
  include Integration::Contracts::ExistsValidation

  KIND = {
    extension: 49,
    addition: 50,
    reduction: 51,
    extension_addition: 52,
    extension_reduction: 53,
    no_type: 54,
    no_value: 55
  }

  # Validations

  ## Presence

  validates :data_aditivo,
    :data_publicacao,
    :flg_tipo_aditivo,
    :isn_contrato_aditivo,
    :isn_ig,
    :isn_sic,
    :valor_acrescimo,
    :valor_reducao,
    :data_publicacao_portal,
    presence: true


  before_save :sanitize_by_confidential, if: :contract_confidential?


  # Public

  ## Class methods

  ### Scopes

  def self.credit
    where(flg_tipo_aditivo: [KIND[:addition], KIND[:extension_addition]])
  end

  def self.credit_sum
    credit.sum(:valor_acrescimo)
  end

  def self.reduction
    where(flg_tipo_aditivo: [KIND[:reduction], KIND[:extension_reduction]])
  end

  def self.reduction_sum
    reduction.sum(:valor_reducao)
  end

  def self.total_addition
    credit_sum - reduction_sum
  end

  ## Instance methods

  ### Helpers

  def title
    isn_contrato_aditivo.to_s
  end

  private

  def sanitize_by_confidential
    self.descricao_url = nil
  end

  def contract_confidential?
    contract.present? and contract.confidential?
  end

end
