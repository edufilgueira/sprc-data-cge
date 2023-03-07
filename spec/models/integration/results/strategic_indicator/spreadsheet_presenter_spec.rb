require 'rails_helper'

describe Integration::Results::StrategicIndicator::SpreadsheetPresenter do
  subject(:strategic_indicator_spreadsheet_presenter) do
    Integration::Results::StrategicIndicator::SpreadsheetPresenter.new(strategic_indicator)
  end

  let(:strategic_indicator) { create(:integration_results_strategic_indicator) }

  let(:klass) { Integration::Results::StrategicIndicator }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:axis_title),
      klass.human_attribute_name(:resultado),
      klass.human_attribute_name(:indicador),
      klass.human_attribute_name(:unidade),
      klass.human_attribute_name(:sigla_orgao),
      klass.human_attribute_name(:orgao),
      klass.human_attribute_name(:valores_realizados),
      klass.human_attribute_name(:valores_atuais)
    ]

    expect(Integration::Results::StrategicIndicator::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      strategic_indicator.axis_title.to_s,
      strategic_indicator.resultado.to_s,
      strategic_indicator.indicador.to_s,
      strategic_indicator.unidade.to_s,
      strategic_indicator.sigla_orgao.to_s,
      strategic_indicator.orgao.to_s,
      strategic_indicator.valores_realizados.to_s,
      strategic_indicator.valores_atuais.to_s
    ]

    result = strategic_indicator_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
