require 'rails_helper'

describe Integration::Macroregions::Region do
  subject(:region) { build(:integration_macroregions_region) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_macroregions_region, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
