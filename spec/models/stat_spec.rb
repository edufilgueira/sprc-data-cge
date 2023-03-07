require 'rails_helper'

describe Stat do
  subject(:stat) { create(:stat) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:type).of_type(:string) }
      it { is_expected.to have_db_column(:month).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }
      it { is_expected.to have_db_column(:data).of_type(:text) }
      it { is_expected.to have_db_column(:month_start).of_type(:integer) }
      it { is_expected.to have_db_column(:month_end).of_type(:integer) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:type) }
      it { is_expected.to have_db_index(:month) }
      it { is_expected.to have_db_index(:year) }
      it { is_expected.to have_db_index([:year, :type, :month]) }
      it { is_expected.to have_db_index([:year, :type, :month_start, :month_end]) }
    end
  end

  describe 'validations' do

    describe 'presence' do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:month) }
      it { is_expected.to validate_presence_of(:year) }
    end

    describe 'uniqueness' do
      it 'month_end blank' do
        stat = create(:stat, month_end: nil)

        is_expected.to validate_uniqueness_of(:month).scoped_to([:year, :type])
      end

      #XXX: essa validação está fazendo com que models que não possuem esse tipo
      # de filtro fiquem inválidos.
      # it { is_expected.to validate_uniqueness_of(:month_end).scoped_to([:year, :type, :month_start]) }
    end

    describe 'inclusion' do
      it { is_expected.to validate_inclusion_of(:month_end).in_range(stat.month_start..12) }
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:data) }
    #
    it { expect(stat.data).to be_a Hash }
  end
end
