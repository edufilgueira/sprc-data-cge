require 'rails_helper'

describe Integration::Supports::ResourceSource do
  subject(:resource_source) { build(:integration_supports_resource_source) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_resource_source, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_fonte).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_fonte) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(resource_source.title).to eq(resource_source.titulo)
    end
  end
end
