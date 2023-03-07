require 'rails_helper'

describe Integration::Supports::ServerRole do

  subject(:integration_supports_server_role) { build(:integration_supports_server_role) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_server, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'associations' do
    it 'server_salaries' do
      expect(integration_supports_server_role).to have_many(:server_salaries).
        with_foreign_key('integration_supports_server_role_id').
        class_name('Integration::Servers::ServerSalary')
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
