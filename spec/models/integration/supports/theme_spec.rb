require 'rails_helper'

describe Integration::Supports::Theme do
  subject(:theme) { build(:integration_supports_theme) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_theme, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_tema).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tema).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_tema) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_tema) }
    it { is_expected.to validate_presence_of(:descricao_tema) }
  end

  describe 'helpers' do
    it 'title' do
      expect(theme.title).to eq(theme.descricao_tema)
    end
  end
end
