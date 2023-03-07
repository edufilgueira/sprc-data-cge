require 'rails_helper'

describe Integration::Supports::Function do
  subject(:function) { build(:integration_supports_function) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_function, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_funcao).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_funcao) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_funcao) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(function.title).to eq(function.titulo)
    end
  end
end
