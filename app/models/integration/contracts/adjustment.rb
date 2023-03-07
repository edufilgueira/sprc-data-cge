class Integration::Contracts::Adjustment < Integration::BaseDataChange
  include Integration::Contracts::SubResource
  include Integration::Contracts::ExistsValidation

  # Validations

  ## Presence

  validates :data_ajuste,
    :data_inclusao,
    :flg_acrescimo_reducao,
    :flg_controle_transmissao,
    :flg_receita_despesa,
    :flg_tipo_ajuste,
    :isn_contrato_ajuste,
    :isn_contrato_tipo_ajuste,
    :ins_edital,
    :isn_sic,
    :isn_situacao,
    :isn_usuario_alteracao,
    :isn_usuario_aprovacao,
    :isn_usuario_auditoria,
    :isn_usuario_exclusao,
    :valor_ajuste_destino,
    :valor_ajuste_origem,
    :valor_inicio_destino,
    :valor_inicio_origem,
    :valor_termino_origem,
    :valor_termino_destino,
    presence: true


  before_save :sanitize_by_confidential, if: :contract_confidential?

  # Public

  ## Class methods

  ### Scopes

  def self.total_adjustments
    sum(:valor_ajuste_destino) + sum(:valor_ajuste_origem)
  end

  ## Instance methods

  ### Helpers

  def title
    isn_contrato_ajuste.to_s
  end


  private

  def sanitize_by_confidential
    self.descricao_url = nil
  end

  def contract_confidential?
    contract.present? and contract.confidential?
  end
end
