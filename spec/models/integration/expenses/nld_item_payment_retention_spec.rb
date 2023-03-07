require 'rails_helper'

describe Integration::Expenses::NldItemPaymentRetention do

  subject(:integration_expenses_nld_item_payment_retention) { build(:integration_expenses_nld_item_payment_retention) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_nld_item_payment_retention, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_retencao).of_type(:string) }
      it { is_expected.to have_db_column(:credor).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:integration_expenses_nld_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:nld) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:nld) }
  end
end
