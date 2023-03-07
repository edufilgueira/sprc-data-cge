require 'rails_helper'

describe PPA::Source::Guideline do
  subject(:guideline) { build(:ppa_source_guideline) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ppa_source_guideline, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_objetivo_estrategico).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_estrategia).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_ppa_objetivo_estrategico).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_ppa_estrategia).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_eixo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_eixo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_tema).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tema).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_programa).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_programa).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_ppa_iniciativa).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_ppa_iniciativa).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_acao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_acao).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_produto).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_produto).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_portal).of_type(:string) }
      it { is_expected.to have_db_column(:prioridade_regional).of_type(:string) }
      it { is_expected.to have_db_column(:ordem_prioridade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_referencia).of_type(:string) }
      it { is_expected.to have_db_column(:valor_programado_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado_ano4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado1619_ar).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado1619_dr).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado_ano4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado1619_ar).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_realizado1619_dr).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_ano4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_creditos_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_creditos_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_creditos_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_creditos_ano4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado_ano4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago_ano1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago_ano2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago_ano3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago_ano4).of_type(:decimal) }

      it { is_expected.to have_db_column(:ano).of_type(:integer) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(%i[
        ano
        codigo_regiao
        codigo_eixo
        codigo_tema
        codigo_ppa_objetivo_estrategico
        codigo_ppa_estrategia
        codigo_programa
        codigo_ppa_iniciativa
        codigo_acao
        codigo_produto
        descricao_referencia
      ]) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_regiao) }
    it { is_expected.to validate_presence_of(:codigo_ppa_objetivo_estrategico) }
    it { is_expected.to validate_presence_of(:codigo_ppa_estrategia) }
    it { is_expected.to validate_presence_of(:codigo_eixo) }
    it { is_expected.to validate_presence_of(:codigo_tema) }
    it { is_expected.to validate_presence_of(:ano) }

    context 'uniqueness' do
      subject(:guideline) { create :ppa_source_guideline }

      it do
        is_expected.to validate_uniqueness_of(:ano)
          .scoped_to(%i[
            codigo_regiao
            codigo_eixo
            codigo_tema
            codigo_ppa_objetivo_estrategico
            codigo_ppa_estrategia
            codigo_programa
            codigo_ppa_iniciativa
            codigo_acao
            codigo_produto
            descricao_referencia
          ]).case_insensitive
      end
    end
  end
end
