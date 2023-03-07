require 'rails_helper'

describe Integration::RealStates::Configuration do

  subject(:configuration) { build(:integration_real_states_configuration) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_real_states_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:user).of_type(:string) }
      it { is_expected.to have_db_column(:password).of_type(:string) }
      it { is_expected.to have_db_column(:operation).of_type(:string) }
      it { is_expected.to have_db_column(:response_path).of_type(:string) }
      it { is_expected.to have_db_column(:detail_operation).of_type(:string) }
      it { is_expected.to have_db_column(:detail_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:last_importation).of_type(:datetime) }
      it { is_expected.to have_db_column(:log).of_type(:text) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:schedule) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:schedule) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:cron_syntax_frequency).to(:schedule) }
  end

  describe 'validations' do
    it { is_expected.to_not validate_presence_of(:headers_soap_action) }
    it { is_expected.to validate_presence_of(:wsdl) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:operation) }
    it { is_expected.to validate_presence_of(:response_path) }
    it { is_expected.to validate_presence_of(:detail_operation) }
    it { is_expected.to validate_presence_of(:detail_response_path) }
    it { is_expected.to validate_presence_of(:schedule) }
  end

  describe 'enums' do
    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]
      is_expected.to define_enum_for(:status).with(statuses)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(configuration.title).to eq configuration.model_name.human
    end

    it 'import' do
      importer = double

      expect(Integration::RealStates::Importer).to receive(:delay) { importer }
      expect(importer).to receive(:call)

      configuration.import
    end

    it 'status_str' do
      configuration.status_success!
      expect(configuration.status_str).to eq I18n.t("integration/base_configuration.statuses.status_success")
    end
  end

end
