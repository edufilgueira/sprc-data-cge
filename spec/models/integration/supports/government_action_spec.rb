require 'rails_helper'

describe Integration::Supports::GovernmentAction do
  subject(:government_action) { build(:integration_supports_government_action) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_government_action, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_acao).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_acao) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_acao) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(government_action.title).to eq(government_action.titulo)
    end
  end
end
