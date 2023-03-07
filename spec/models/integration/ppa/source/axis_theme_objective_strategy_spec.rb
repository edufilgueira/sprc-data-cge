require 'rails_helper'

RSpec.describe Integration::PPA::Source::AxisThemeObjectiveStrategy, type: :model do
  subject(:configuration) { build(:integration_ppa_source_axis_theme_objective_strategy) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:eixo_cod).of_type(:string) }
      it { is_expected.to have_db_column(:eixo_descricao).of_type(:text) }
      it { is_expected.to have_db_column(:eixo_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:estrategia_cod).of_type(:string) }
      it { is_expected.to have_db_column(:estrategia_descricao).of_type(:text) }
      it { is_expected.to have_db_column(:objetivo_cod).of_type(:string) }
      it { is_expected.to have_db_column(:objetivo_descricao).of_type(:text) }
      it { is_expected.to have_db_column(:ppa_ano_fim).of_type(:string) }
      it { is_expected.to have_db_column(:ppa_ano_inicio).of_type(:string) }
      it { is_expected.to have_db_column(:regiao_cod).of_type(:string) }
      it { is_expected.to have_db_column(:regiao_descricao).of_type(:string) }
      it { is_expected.to have_db_column(:regiao_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:tema_cod).of_type(:string) }
      it { is_expected.to have_db_column(:tema_descricao).of_type(:text) }
      it { is_expected.to have_db_column(:tema_descricao_detalhada).of_type(:text) }
      it { is_expected.to have_db_column(:tema_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:regiao_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:estrategia_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:objetivo_isn).of_type(:integer) }
    end
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:eixo_isn) }
    it { is_expected.to have_db_index(:tema_isn) }
    it { is_expected.to have_db_index(:regiao_isn) }
    it { is_expected.to have_db_index(:estrategia_isn) }
    it { is_expected.to have_db_index(:objetivo_isn) }
  end

end