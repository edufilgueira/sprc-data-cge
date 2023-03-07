require 'rails_helper'

describe Integration::Supports::Axis do
  subject(:axis) { build(:integration_supports_axis) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_axis, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_eixo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_eixo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_eixo) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_eixo) }
    it { is_expected.to validate_presence_of(:descricao_eixo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(axis.title).to eq(axis.descricao_eixo)
    end
  end
end
