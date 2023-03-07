require 'rails_helper'

describe Integration::Supports::ExpenseNatureGroup do
  subject(:expense_nature_group) { build(:integration_supports_expense_nature_group) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_nature_group, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_grupo_natureza).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_grupo_natureza) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_grupo_natureza) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_nature_group.title).to eq(expense_nature_group.titulo)
    end
  end
end
