require 'rails_helper'

describe Integration::RealStates::RealState do

  subject(:contract) { build(:integration_real_states_real_state) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_real_states_real_state, :invalid)).to be_invalid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :municipio }
    it { is_expected.to validate_presence_of :service_id }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:manager_id).of_type(:integer) }
      it { is_expected.to have_db_column(:property_type_id).of_type(:integer) }
      it { is_expected.to have_db_column(:occupation_type_id).of_type(:integer) }

      it { is_expected.to have_db_column(:service_id).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_imovel).of_type(:string) }
      it { is_expected.to have_db_column(:estado).of_type(:string) }
      it { is_expected.to have_db_column(:municipio).of_type(:string) }
      it { is_expected.to have_db_column(:area_projecao_construcao).of_type(:decimal) }
      it { is_expected.to have_db_column(:area_medida_in_loco).of_type(:decimal) }
      it { is_expected.to have_db_column(:area_registrada).of_type(:decimal) }
      it { is_expected.to have_db_column(:frente).of_type(:decimal) }
      it { is_expected.to have_db_column(:fundo).of_type(:decimal) }
      it { is_expected.to have_db_column(:lateral_direita).of_type(:decimal) }
      it { is_expected.to have_db_column(:lateral_esquerda).of_type(:decimal) }
      it { is_expected.to have_db_column(:taxa_ocupacao).of_type(:decimal) }
      it { is_expected.to have_db_column(:fracao_ideal).of_type(:decimal) }
      it { is_expected.to have_db_column(:numero_imovel).of_type(:string) }
      it { is_expected.to have_db_column(:utm_zona).of_type(:string) }
      it { is_expected.to have_db_column(:bairro).of_type(:string) }
      it { is_expected.to have_db_column(:cep).of_type(:string) }
      it { is_expected.to have_db_column(:endereco).of_type(:string) }
      it { is_expected.to have_db_column(:complemento).of_type(:string) }
      it { is_expected.to have_db_column(:lote).of_type(:string) }
      it { is_expected.to have_db_column(:quadra).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

      describe 'indexes' do
        it { is_expected.to have_db_index(:manager_id) }
        it { is_expected.to have_db_index(:property_type_id) }
        it { is_expected.to have_db_index(:occupation_type_id) }
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:manager) }
    it { is_expected.to belong_to(:property_type) }
    it { is_expected.to belong_to(:occupation_type) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:property_type).with_prefix }
    it { is_expected.to delegate_method(:title).to(:occupation_type).with_prefix }
    it { is_expected.to delegate_method(:title).to(:manager).with_prefix }
  end
end
