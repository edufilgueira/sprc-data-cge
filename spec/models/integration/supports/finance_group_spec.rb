require 'rails_helper'

describe Integration::Supports::FinanceGroup do
  subject(:finance_group) { build(:integration_supports_finance_group) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_finance_group, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_grupo_financeiro).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_grupo_financeiro) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_grupo_financeiro) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(finance_group.title).to eq(finance_group.titulo)
    end
  end
end
