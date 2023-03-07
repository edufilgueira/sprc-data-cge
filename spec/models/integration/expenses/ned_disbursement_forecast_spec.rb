require 'rails_helper'

describe Integration::Expenses::NedDisbursementForecast do

  subject(:integration_expenses_ned_disbursement_forecast) { build(:integration_expenses_ned_disbursement_forecast) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_ned_disbursement_forecast, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:data).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }

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
