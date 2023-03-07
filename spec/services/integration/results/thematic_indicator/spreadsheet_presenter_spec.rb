require 'rails_helper'

describe Integration::Results::ThematicIndicator::SpreadsheetPresenter do
  subject(:thematic_indicator_spreadsheet_presenter) do
    Integration::Results::ThematicIndicator::SpreadsheetPresenter.new(thematic_indicator)
  end

  let(:thematic_indicator) { create(:integration_results_thematic_indicator) }

  let(:klass) { Integration::Results::ThematicIndicator }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:axis_title),
      klass.human_attribute_name(:theme_title),
      klass.human_attribute_name(:resultado),
      klass.human_attribute_name(:indicador),
      klass.human_attribute_name(:unidade),
      klass.human_attribute_name(:sigla_orgao),
      klass.human_attribute_name(:orgao),
      klass.human_attribute_name(:valores_realizados),
      klass.human_attribute_name(:valores_programados)
    ]

    expect(Integration::Results::ThematicIndicator::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      thematic_indicator.axis_title.to_s,
      thematic_indicator.theme_title.to_s,
      thematic_indicator.resultado.to_s,
      thematic_indicator.indicador.to_s,
      thematic_indicator.unidade.to_s,
      thematic_indicator.sigla_orgao.to_s,
      thematic_indicator.orgao.to_s,
      thematic_indicator.valores_realizados.to_s,
      thematic_indicator.valores_programados.to_s
    ]

    result = thematic_indicator_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
