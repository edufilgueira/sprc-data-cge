require 'rails_helper'

describe Integration::Macroregions::SpreadsheetPresenter do
  subject(:investment_spreadsheet_presenter) do
    Integration::Macroregions::SpreadsheetPresenter.new(investment)
  end

  let(:investment) { create(:integration_macroregions_macroregion_investiment) }

  let(:klass) { Integration::Macroregions::MacroregionInvestiment }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:ano_exercicio),
      klass.human_attribute_name(:codigo_poder),
      klass.human_attribute_name(:descricao_poder),
      klass.human_attribute_name(:codigo_regiao),
      klass.human_attribute_name(:descricao_regiao),
      klass.human_attribute_name(:valor_lei),
      klass.human_attribute_name(:valor_lei_creditos),
      klass.human_attribute_name(:valor_empenhado),
      klass.human_attribute_name(:valor_pago),
      klass.human_attribute_name(:perc_empenho),
      klass.human_attribute_name(:perc_pago_calculated)
    ]

    expect(Integration::Macroregions::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      investment.ano_exercicio.to_s,
      investment.codigo_poder.to_s,
      investment.descricao_poder.to_s,
      investment.codigo_regiao.to_s,
      investment.descricao_regiao.to_s,
      investment.valor_lei.to_s,
      investment.valor_lei_creditos.to_s,
      investment.valor_empenhado.to_s,
      investment.valor_pago.to_s,
      investment.perc_empenho.to_s,
      investment.perc_pago_calculated.to_s
    ]

    result = investment_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
