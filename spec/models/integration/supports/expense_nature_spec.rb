require 'rails_helper'

describe Integration::Supports::ExpenseNature do
  subject(:expense_nature) { build(:integration_supports_expense_nature) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_nature, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_natureza_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_natureza_despesa) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_natureza_despesa) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_nature.title).to eq(expense_nature.titulo)
    end
  end
end
