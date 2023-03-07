require 'rails_helper'

describe Integration::Supports::PaymentRetentionType do
  subject(:payment_retention_type) { build(:integration_supports_payment_retention_type) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_payment_retention_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_retencao).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_retencao) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_retencao) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(payment_retention_type.title).to eq(payment_retention_type.titulo)
    end
  end
end
