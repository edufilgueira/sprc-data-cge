require 'rails_helper'

describe Integration::Supports::ManagementUnit do
  subject(:management_unit) { build(:integration_supports_management_unit) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_management_unit, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cgf).of_type(:string) }
      it { is_expected.to have_db_column(:cnpj).of_type(:string) }
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_credor).of_type(:string) }
      it { is_expected.to have_db_column(:poder).of_type(:string) }
      it { is_expected.to have_db_column(:sigla).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_administracao).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_de_ug).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:cgf) }
      it { is_expected.to have_db_index(:cnpj) }
      it { is_expected.to have_db_index(:codigo) }
      it { is_expected.to have_db_index(:codigo_credor) }
      it { is_expected.to have_db_index(:poder) }
      it { is_expected.to have_db_index(:sigla) }
      it { is_expected.to have_db_index(:tipo_administracao) }
      it { is_expected.to have_db_index(:tipo_de_ug) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_presence_of(:codigo) }
    it { is_expected.to validate_presence_of(:poder) }
    it { is_expected.to validate_presence_of(:sigla) }
    it { is_expected.to validate_presence_of(:tipo_administracao) }
    it { is_expected.to validate_presence_of(:tipo_de_ug) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(management_unit.title).to eq(management_unit.titulo)
    end
  end
end
