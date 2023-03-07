require 'rails_helper'

describe Integration::Supports::Product do
  subject(:product) { build(:integration_supports_product) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_product, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(product.title).to eq(product.titulo)
    end
  end
end
