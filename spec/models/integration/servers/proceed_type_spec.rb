require 'rails_helper'

describe Integration::Servers::ProceedType  do
  subject(:integration_servers_proceed_type) { build(:integration_servers_proceed_type) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_proceed_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cod_provento).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_provento).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_tipo).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:cod_provento) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cod_provento) }
    it { is_expected.to validate_presence_of(:dsc_provento) }
    it { is_expected.to validate_presence_of(:dsc_tipo) }
  end
end
