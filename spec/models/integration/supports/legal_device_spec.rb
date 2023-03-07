require 'rails_helper'

describe Integration::Supports::LegalDevice do
  subject(:legal_device) { build(:integration_supports_legal_device) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_legal_device, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao).of_type(:text) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo) }
    it { is_expected.to validate_presence_of(:descricao) }
  end

  describe 'helpers' do
    it 'title' do
      expect(legal_device.title).to eq(legal_device.descricao)
    end
  end
end
