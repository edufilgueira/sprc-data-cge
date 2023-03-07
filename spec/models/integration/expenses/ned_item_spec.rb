require 'rails_helper'

describe Integration::Expenses::NedItem do

  subject(:integration_expenses_ned_item) { build(:integration_expenses_ned_item) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_ned_item, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:sequencial).of_type(:integer) }
      it { is_expected.to have_db_column(:especificacao).of_type(:string) }
      it { is_expected.to have_db_column(:unidade).of_type(:string) }
      it { is_expected.to have_db_column(:quantidade).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_unitario).of_type(:decimal) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:integration_expenses_ned_id) }
    end

  end

  describe 'associations' do
    it { is_expected.to belong_to(:ned) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ned) }
  end
end
