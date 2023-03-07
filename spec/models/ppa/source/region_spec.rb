require 'rails_helper'

describe PPA::Source::Region do
  subject(:region) { build(:ppa_source_region) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ppa_source_region, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_regiao).of_type(:string) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_regiao) }
    it { is_expected.to validate_presence_of(:descricao_regiao) }
  end
end
