require 'rails_helper'

describe Integration::Results::StrategicIndicator do

  subject(:strategic_indicator) { build(:integration_results_strategic_indicator) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_results_strategic_indicator, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:eixo).of_type(:jsonb) }
      it { is_expected.to have_db_column(:resultado).of_type(:string) }
      it { is_expected.to have_db_column(:indicador).of_type(:string) }
      it { is_expected.to have_db_column(:unidade).of_type(:string) }
      it { is_expected.to have_db_column(:sigla_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:orgao).of_type(:string) }
      it { is_expected.to have_db_column(:valores_realizados).of_type(:jsonb) }
      it { is_expected.to have_db_column(:valores_atuais).of_type(:jsonb) }

      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:axis_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:axis_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:axis) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:eixo) }
    it { is_expected.to validate_presence_of(:indicador) }
    it { is_expected.to validate_presence_of(:sigla_orgao) }
    it { is_expected.to validate_presence_of(:organ) }
    it { is_expected.to validate_presence_of(:axis) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:sigla).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:axis).with_prefix }
  end
end
