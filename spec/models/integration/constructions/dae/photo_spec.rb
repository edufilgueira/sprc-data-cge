require 'rails_helper'

describe Integration::Constructions::Dae::Photo do
  describe 'associations' do
    it { is_expected.to belong_to(:integration_constructions_dae).class_name('Integration::Constructions::Dae') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :integration_constructions_dae }
    it { is_expected.to validate_presence_of :codigo_obra }
    it { is_expected.to validate_presence_of :id_medicao }
  end

  describe 'callbacks' do
    it 'notify_create' do
      dae = create(:integration_constructions_dae_photo)

      expect(dae.utils_data_change.new_resource_notificable?).to be_truthy
      expect(dae.data_changes).to eq(nil)
    end
  end
end
