require 'rails_helper'

describe Integration::Supports::ApplicationModality do
  subject(:application_modality) { build(:integration_supports_application_modality) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_application_modality, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_modalidade).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_modalidade) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_modalidade) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(application_modality.title).to eq(application_modality.titulo)
    end
  end
end
