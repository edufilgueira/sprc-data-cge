class ::Integration::Contracts::Contract::SpreadsheetPresenter

  COLUMNS = [
    :data_assinatura,
    :data_termino_original,
    :data_termino,
    :data_rescisao,
    :isn_sic,
    :num_contrato,
    :num_spu,
    :cpf_cnpj_financiador,
    :manager_title,
    :grantor_title,
    :creditor_title,
    :status_str,
    :descricao_situacao,
    :decricao_modalidade,
    :tipo_objeto,
    :descricao_objeto,
    :descricao_justificativa,
    :valor_contrato,
    :calculated_valor_aditivo,
    :valor_can_rstpg,
    :valor_atualizado_concedente,
    :calculated_valor_empenhado,
    :calculated_valor_pago
  ].freeze

  attr_reader :contract

  def initialize(contract)
    @contract = contract
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      if (self.respond_to?(column))
        self.send(column)
      else
        contract.send(column)
      end
    end
  end

  # Override

  def data_assinatura
    I18n.l(contract.data_assinatura.to_date)
  end

  def data_termino
    I18n.l(contract.data_termino.to_date)
  end

  def data_termino_original
    I18n.l(contract.data_termino_original.to_date) if contract.data_termino_original.present?
  end

  def data_rescisao
    I18n.l(contract.data_rescisao.to_date) if contract.data_rescisao.present?
  end

  def data_publicacao_portal
    I18n.l(contract.data_publicacao_portal.to_date)
  end

  def manager_title
    contract.manager_title || contract.cod_gestora
  end

  def grantor_title
    contract.grantor_title || contract.cod_concedente
  end

  def creditor_title
    contract.descricao_nome_credor
  end

  private

  def self.spreadsheet_header_title(column)
    ::Integration::Contracts::Contract.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
