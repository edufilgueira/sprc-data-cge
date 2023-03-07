require 'rails_helper'

describe OpenData::VcgeCategoryAssociation do
  subject(:vcge_category_association) { build(:vcge_category_association) }

  it_behaves_like 'models/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
      it { is_expected.to have_db_column(:child_id).of_type(:integer) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:parent_id) }
      it { is_expected.to have_db_index(:child_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:parent).class_name('OpenData::VcgeCategory') }
    it { is_expected.to belong_to(:child).class_name('OpenData::VcgeCategory') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:parent) }
    it { is_expected.to validate_presence_of(:child) }
  end
end
