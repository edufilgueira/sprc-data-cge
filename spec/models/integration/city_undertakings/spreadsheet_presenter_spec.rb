require 'rails_helper'

describe Integration::CityUndertakings::SpreadsheetPresenter do

  subject(:city_undertaking_spreadsheet_presenter) do
    Integration::CityUndertakings::SpreadsheetPresenter.new(city_undertaking)
  end

  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking) }

  let(:klass) { Integration::CityUndertakings::CityUndertaking }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:municipio),
      klass.human_attribute_name(:tipo_despesa),
      klass.human_attribute_name(:sic),
      klass.human_attribute_name(:mapp),
      klass.human_attribute_name(:organ_title),
      klass.human_attribute_name(:creditor_title),
      klass.human_attribute_name(:undertaking_title),
      klass.human_attribute_name(:valor_programado1),
      klass.human_attribute_name(:valor_programado2),
      klass.human_attribute_name(:valor_programado3),
      klass.human_attribute_name(:valor_programado4),
      klass.human_attribute_name(:valor_programado5),
      klass.human_attribute_name(:valor_programado6),
      klass.human_attribute_name(:valor_programado7),
      klass.human_attribute_name(:valor_programado8),
      klass.human_attribute_name(:valor_executado1),
      klass.human_attribute_name(:valor_executado2),
      klass.human_attribute_name(:valor_executado3),
      klass.human_attribute_name(:valor_executado4),
      klass.human_attribute_name(:valor_executado5),
      klass.human_attribute_name(:valor_executado6),
      klass.human_attribute_name(:valor_executado7),
      klass.human_attribute_name(:valor_executado8)
    ]

    expect(Integration::CityUndertakings::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      city_undertaking.municipio.to_s,
      city_undertaking.tipo_despesa.to_s,
      city_undertaking.sic.to_s,
      city_undertaking.mapp.to_s,
      city_undertaking.organ_title.to_s,
      city_undertaking.creditor_title.to_s,
      city_undertaking.undertaking_title.to_s,
      city_undertaking.valor_programado1.to_s,
      city_undertaking.valor_programado2.to_s,
      city_undertaking.valor_programado3.to_s,
      city_undertaking.valor_programado4.to_s,
      city_undertaking.valor_programado5.to_s,
      city_undertaking.valor_programado6.to_s,
      city_undertaking.valor_programado7.to_s,
      city_undertaking.valor_programado8.to_s,
      city_undertaking.valor_executado1.to_s,
      city_undertaking.valor_executado2.to_s,
      city_undertaking.valor_executado3.to_s,
      city_undertaking.valor_executado4.to_s,
      city_undertaking.valor_executado5.to_s,
      city_undertaking.valor_executado6.to_s,
      city_undertaking.valor_executado7.to_s,
      city_undertaking.valor_executado8.to_s,
    ]

    result = city_undertaking_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
