require 'rails_helper'

describe Transparency::Follower do
  subject(:follower) { build(:transparency_follower) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:transparency_follower, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do

      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:resourceable_id).of_type(:integer) }
      it { is_expected.to have_db_column(:resourceable_type).of_type(:string) }
      it { is_expected.to have_db_column(:transparency_link).of_type(:string) }
      it { is_expected.to have_db_column(:unsubscribed_at).of_type(:datetime) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:email) }
      it { is_expected.to have_db_index(:unsubscribed_at) }
      it { is_expected.to have_db_index([:resourceable_id, :resourceable_type]) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:resourceable) }
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:resourceable) }
      it { is_expected.to validate_presence_of(:transparency_link) }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).scoped_to([:resourceable_id, :resourceable_type, :unsubscribed_at]) }
    end
  end
end
