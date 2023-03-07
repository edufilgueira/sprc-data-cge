require 'rails_helper'

describe OpenData::DataSet do
  subject(:data_set) { build(:data_set) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:source_catalog).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:author).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:organ_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ).class_name('Integration::Supports::Organ') }

    it { is_expected.to have_many(:data_items).with_foreign_key(:open_data_data_set_id).dependent(:destroy) }
    it { is_expected.to have_many(:data_set_vcge_categories).with_foreign_key(:open_data_data_set_id).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:organ) }
  end
end
