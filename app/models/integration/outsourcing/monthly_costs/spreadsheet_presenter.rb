class Integration::Outsourcing::MonthlyCosts::SpreadsheetPresenter

  COLUMNS = [
    :nome,
    :orgao,
    :categoria,
    :nome_contratante,
    :vlr_salario_base,
    :vlr_adicional,
    :vlr_adicional_noturno,
    :vlr_insalubridade,
    :vlr_periculosidade,
    :vlr_vale_transporte,
    :vlr_vale_refeicao,
    :vlr_cesta_basica,
    :vlr_hora_extra,
    :vlr_dsr,
    :vlr_custo_total,
    :remuneracao,
  ]

  attr_reader :monthly_cost

  def initialize(monthly_cost)
    @monthly_cost = monthly_cost
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      monthly_cost.send(column)
    end
  end

  private

  def self.spreadsheet_header_title(column)
    I18n.t("transparency.outsourcing.monthly_costs.presenter.header.#{column}")
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
