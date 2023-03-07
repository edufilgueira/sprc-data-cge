require 'rails_helper'

describe PPA::Source::AxisTheme do
  subject(:axis_theme) { build(:ppa_source_axis_theme) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ppa_source_axis_theme, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_eixo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_eixo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_tema).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tema).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tema_detalhado).of_type(:string) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_eixo) }
    it { is_expected.to validate_presence_of(:codigo_tema) }
    it { is_expected.to validate_presence_of(:descricao_eixo) }
    it { is_expected.to validate_presence_of(:descricao_tema) }

    context 'uniqueness' do
      subject(:axis_theme) { create :ppa_source_axis_theme }

      it { is_expected.to validate_uniqueness_of(:codigo_eixo).scoped_to(:codigo_tema).case_insensitive }
    end
  end
end
