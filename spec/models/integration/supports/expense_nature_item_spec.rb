require 'rails_helper'

describe Integration::Supports::ExpenseNatureItem do
  subject(:expense_nature_item) { build(:integration_supports_expense_nature_item) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_nature_item, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_item_natureza).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_item_natureza) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_item_natureza) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_nature_item.title).to eq(expense_nature_item.titulo)
    end
  end
end
