require 'rails_helper'

describe Integration::Supports::EconomicCategory do
  subject(:economic_category) { build(:integration_supports_economic_category) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_economic_category, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_categoria_economica).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_categoria_economica) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_categoria_economica) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(economic_category.title).to eq(economic_category.titulo)
    end
  end
end
