require 'rails_helper'

describe Integration::Supports::ExpenseType do
  subject(:expense_type) { build(:integration_supports_expense_type) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_type.title).to eq(expense_type.codigo)
    end
  end
end
