require 'rails_helper'

describe OpenData::DataItem do
  subject(:data_item) { build(:data_item) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:data_item_type).of_type(:integer) }
      it { is_expected.to have_db_column(:open_data_data_set_id).of_type(:integer) }
      it { is_expected.to have_db_column(:document_public_filename).of_type(:string) }
      it { is_expected.to have_db_column(:document_format).of_type(:string) }

      # WebService

      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:response_path).of_type(:string) }
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:parameters).of_type(:string) }
      it { is_expected.to have_db_column(:operation).of_type(:string) }
      it { is_expected.to have_db_column(:processed_at).of_type(:datetime) }

      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:last_error).of_type(:text) }

      # Attachement

      it { is_expected.to have_db_column(:document_id).of_type(:string) }
      it { is_expected.to have_db_column(:document_filename).of_type(:string) }
      it { is_expected.to have_db_column(:document_content_size).of_type(:string) }
      it { is_expected.to have_db_column(:document_content_type).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:status) }
      it { is_expected.to have_db_index(:open_data_data_set_id) }
      it { is_expected.to have_db_index(:data_item_type) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:data_set).with_foreign_key(:open_data_data_set_id).class_name('OpenData::DataSet') }
  end

  describe 'enums' do
    it 'data_item_type' do
      data_item_types = [:file, :webservice]

      is_expected.to define_enum_for(:data_item_type).with(data_item_types)
    end

    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]

      is_expected.to define_enum_for(:status).with(statuses)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:data_item_type) }
    it { is_expected.to validate_presence_of(:data_set) }
    it { is_expected.to validate_presence_of(:document_public_filename) }

    context 'file' do
      before { data_item.data_item_type = :file }

      it { is_expected.to validate_presence_of(:document) }
    end

    context 'webservice' do
      before { data_item.data_item_type = :webservice }

      it { is_expected.to validate_presence_of(:status) }
      it { is_expected.to validate_presence_of(:response_path) }
      it { is_expected.to validate_presence_of(:wsdl) }
      it { is_expected.to validate_presence_of(:operation) }
    end
  end

  describe 'import' do

    it 'sets data_item as queued' do

      # evita que seja enviado pra fila pois só queremos checar se o status é
      # alterado antes do job ser processado.
      call_double = double
      allow(call_double).to receive(:call).and_return(nil)
      allow(OpenData::Importer).to receive(:delay).and_return(call_double)

      data_item.status_success!

      data_item.import

      expect(data_item).to be_status_queued
    end
  end
end
