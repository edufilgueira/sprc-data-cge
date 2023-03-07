require 'rails_helper'

describe Stats::ServerSalary do
  subject(:stats_server_salary) { create(:stats_server_salary) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:month).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }
      it { is_expected.to have_db_column(:data).of_type(:text) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:month) }
      it { is_expected.to have_db_index(:year) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_presence_of(:year) }
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:data) }
    #
    it { expect(stats_server_salary.data).to be_a Hash }
  end
end
