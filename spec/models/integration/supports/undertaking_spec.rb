require 'rails_helper'

RSpec.describe Integration::Supports::Undertaking, type: :model do
  subject(:undertaking) { build(:integration_supports_undertaking) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_undertaking, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:descricao).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:descricao) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:descricao) }
  end

  describe 'helpers' do
    it 'title' do
      expect(undertaking.title).to eq(undertaking.descricao)
    end
  end
end
