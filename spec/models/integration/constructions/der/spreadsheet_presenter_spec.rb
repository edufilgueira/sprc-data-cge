require 'rails_helper'

describe Integration::Constructions::Der::SpreadsheetPresenter do

  subject(:der_spreadsheet_presenter) do
    Integration::Constructions::Der::SpreadsheetPresenter.new(der)
  end

  let(:der) { create(:integration_constructions_der) }

  let(:klass) { Integration::Constructions::Der }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:base),
      klass.human_attribute_name(:cerca),
      klass.human_attribute_name(:conclusao),
      klass.human_attribute_name(:construtora),
      klass.human_attribute_name(:cor_status),
      klass.human_attribute_name(:data_fim_contrato),
      klass.human_attribute_name(:data_fim_previsto),
      klass.human_attribute_name(:distrito),
      klass.human_attribute_name(:drenagem),
      klass.human_attribute_name(:extensao),
      klass.human_attribute_name(:id_obra),
      klass.human_attribute_name(:numero_contrato_der),
      klass.human_attribute_name(:numero_contrato_ext),
      klass.human_attribute_name(:numero_contrato_sic),
      klass.human_attribute_name(:obra_darte),
      klass.human_attribute_name(:percentual_executado),
      klass.human_attribute_name(:programa),
      klass.human_attribute_name(:qtd_empregos),
      klass.human_attribute_name(:qtd_geo_referencias),
      klass.human_attribute_name(:revestimento),
      klass.human_attribute_name(:rodovia),
      klass.human_attribute_name(:servicos),
      klass.human_attribute_name(:sinalizacao),
      klass.human_attribute_name(:status),
      klass.human_attribute_name(:supervisora),
      klass.human_attribute_name(:terraplanagem),
      klass.human_attribute_name(:trecho),
      klass.human_attribute_name(:ult_atual),
      klass.human_attribute_name(:valor_aprovado),
      klass.human_attribute_name(:data_inicio_obra),
      klass.human_attribute_name(:data_ordem_servico),
      klass.human_attribute_name(:dias_adicionado),
      klass.human_attribute_name(:dias_suspenso),
      klass.human_attribute_name(:municipio),
      klass.human_attribute_name(:numero_ordem_servico),
      klass.human_attribute_name(:prazo_inicial),
      klass.human_attribute_name(:total_aditivo),
      klass.human_attribute_name(:total_reajuste),
      klass.human_attribute_name(:valor_atual),
      klass.human_attribute_name(:valor_original),
      klass.human_attribute_name(:valor_pi)
    ]

    expect(Integration::Constructions::Der::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      der.base,
      der.cerca,
      der.conclusao.to_s,
      der.construtora,
      der.cor_status,
      der.data_fim_contrato.to_s,
      der.data_fim_previsto.to_s,
      der.distrito,
      der.drenagem,
      der.extensao.to_s,
      der.id_obra.to_s,
      der.numero_contrato_der,
      der.numero_contrato_ext,
      der.numero_contrato_sic,
      der.obra_darte,
      der.percentual_executado.to_s,
      der.programa,
      der.qtd_empregos.to_s,
      der.qtd_geo_referencias.to_s,
      der.revestimento,
      der.rodovia,
      der.servicos,
      der.sinalizacao,
      der.status,
      der.supervisora,
      der.terraplanagem,
      der.trecho,
      der.ult_atual.to_s,
      der.valor_aprovado.to_s,
      der.data_inicio_obra.to_s,
      der.data_ordem_servico.to_s,
      der.dias_adicionado.to_s,
      der.dias_suspenso.to_s,
      der.municipio.to_s,
      der.numero_ordem_servico.to_s,
      der.prazo_inicial.to_s,
      der.total_aditivo.to_s,
      der.total_reajuste.to_s,
      der.valor_atual.to_s,
      der.valor_original.to_s,
      der.valor_pi.to_s
    ]

    result = der_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
