require 'rails_helper'

describe Integration::Supports::ExpenseElement do
  subject(:expense_element) { build(:integration_supports_expense_element) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_element, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_elemento_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:eh_elementar).of_type(:boolean) }
      it { is_expected.to have_db_column(:eh_licitacao).of_type(:boolean) }
      it { is_expected.to have_db_column(:eh_transferencia).of_type(:boolean) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_elemento_despesa) }
      it { is_expected.to have_db_index(:eh_elementar) }
      it { is_expected.to have_db_index(:eh_licitacao) }
      it { is_expected.to have_db_index(:eh_transferencia) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_elemento_despesa) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_element.title).to eq(expense_element.titulo)
    end
  end
end
