require 'rails_helper'

describe Transparency::Export do

  subject(:transparency_export) { build(:transparency_export) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:transparency_export, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:query).of_type(:string) }
      it { is_expected.to have_db_column(:resource_name).of_type(:string) }
      it { is_expected.to have_db_column(:expiration).of_type(:datetime) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:query) }
    it { is_expected.to validate_presence_of(:worksheet_format) }
    it { is_expected.to validate_presence_of(:resource_name) }
  end

  describe 'enum' do

    it 'statuses' do
      statuses = [
        :queued,
        :in_progress,
        :error,
        :success
      ]

      is_expected.to define_enum_for(:status).with(statuses)
    end

    it 'worksheet_format' do
      worksheet_formats = [
        :xlsx,
        :csv
      ]

      is_expected.to define_enum_for(:worksheet_format).with(worksheet_formats)
    end

  end
end
