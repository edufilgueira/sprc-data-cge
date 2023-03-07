require 'rails_helper'

describe Integration::RealStates::SpreadsheetPresenter do

  subject(:real_state_spreadsheet_presenter) do
    Integration::RealStates::SpreadsheetPresenter.new(real_state)
  end

  let(:real_state) { create(:integration_real_states_real_state) }

  let(:klass) { Integration::RealStates::RealState }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:service_id),
      klass.human_attribute_name(:descricao_imovel),
      klass.human_attribute_name(:property_type_title),
      klass.human_attribute_name(:occupation_type_title),
      klass.human_attribute_name(:estado),
      klass.human_attribute_name(:municipio),
      klass.human_attribute_name(:area_projecao_construcao),
      klass.human_attribute_name(:area_medida_in_loco),
      klass.human_attribute_name(:area_registrada),
      klass.human_attribute_name(:frente),
      klass.human_attribute_name(:fundo),
      klass.human_attribute_name(:lateral_direita),
      klass.human_attribute_name(:lateral_esquerda),
      klass.human_attribute_name(:taxa_ocupacao),
      klass.human_attribute_name(:fracao_ideal),
      klass.human_attribute_name(:numero_imovel),
      klass.human_attribute_name(:utm_zona),
      klass.human_attribute_name(:bairro),
      klass.human_attribute_name(:cep),
      klass.human_attribute_name(:endereco),
      klass.human_attribute_name(:complemento),
      klass.human_attribute_name(:lote),
      klass.human_attribute_name(:quadra)
    ]

    expect(Integration::RealStates::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      real_state.service_id.to_s,
      real_state.descricao_imovel.to_s,
      real_state.property_type_title.to_s,
      real_state.occupation_type_title.to_s,
      real_state.estado.to_s,
      real_state.municipio.to_s,
      real_state.area_projecao_construcao.to_s,
      real_state.area_medida_in_loco.to_s,
      real_state.area_registrada.to_s,
      real_state.frente.to_s,
      real_state.fundo.to_s,
      real_state.lateral_direita.to_s,
      real_state.lateral_esquerda.to_s,
      real_state.taxa_ocupacao.to_s,
      real_state.fracao_ideal.to_s,
      real_state.numero_imovel.to_s,
      real_state.utm_zona.to_s,
      real_state.bairro.to_s,
      real_state.cep.to_s,
      real_state.endereco.to_s,
      real_state.complemento.to_s,
      real_state.lote.to_s,
      real_state.quadra.to_s
    ]

    result = real_state_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
