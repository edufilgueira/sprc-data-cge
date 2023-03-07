class Integration::Contracts::Convenant::SpreadsheetPresenter

  COLUMNS = [
    :data_assinatura,
    :data_termino_original,
    :data_termino,
    :data_rescisao,
    :data_publicacao_portal,
    :isn_sic,
    :num_contrato,
    :cod_plano_trabalho,
    :cpf_cnpj_financiador,
    :status_str,
    :accountability_status,
    :manager_title,
    :grantor_title,
    :creditor_title,
    :descriaco_edital,
    :descricao_situacao,
    :decricao_modalidade,
    :tipo_objeto,
    :descricao_objeto,
    :descricao_justificativa,
    :valor_contrato,
    :valor_can_rstpg,
    :valor_original_concedente,
    :valor_original_contrapartida,
    :valor_atualizado_contrapartida,
    :valor_atualizado_concedente,
    :valor_atualizado_total,
    :calculated_valor_empenhado,
    :calculated_valor_pago
  ].freeze

  attr_reader :convenant

  def initialize(convenant)
    @convenant = convenant
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
        convenant.send(column)
      end
    end
  end

  # Override

  def data_assinatura
    I18n.l(convenant.data_assinatura.to_date)
  end

  def data_termino
    I18n.l(convenant.data_termino.to_date)
  end

  def data_termino_original
    I18n.l(convenant.data_termino_original.to_date) if convenant.data_termino_original.present?
  end

  def data_rescisao
    I18n.l(convenant.data_rescisao.to_date) if convenant.data_rescisao.present?
  end

  def data_publicacao_portal
    I18n.l(convenant.data_publicacao_portal.to_date)
  end

  def manager_title
    convenant.manager_title || convenant.cod_gestora
  end

  def grantor_title
    convenant.grantor_title || convenant.cod_concedente
  end

  def creditor_title
    convenant.descricao_nome_credor
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Contracts::Convenant.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
