require 'rails_helper'

describe Integration::Supports::Organ::Search do
  it 'descricao_orgao' do
    organ = create(:integration_supports_organ, descricao_orgao: 'HOSPITAL GERAL DA POLÍCIA MILITAR JOSÉ MARTINIANO DE ALENCAR')
    create(:integration_supports_organ, descricao_orgao: 'SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA')

    organs = Integration::Supports::Organ.search('HOSP')
    expect(organs).to eq([organ])
  end

  it 'codigo_orgao' do
    organ = create(:integration_supports_organ, codigo_orgao: 'codigo_com_letras')
    create(:integration_supports_organ, codigo_orgao: '321')

    organs = Integration::Supports::Organ.search('codigo_com_letras')
    expect(organs).to eq([organ])
  end

  it 'sigla' do
    organ = create(:integration_supports_organ, sigla: 'PM')
    create(:integration_supports_organ, sigla: 'ARCE')

    organs = Integration::Supports::Organ.search('PM')
    expect(organs).to eq([organ])
  end
end
