require 'rails_helper'

describe Integration::Macroregions::MacroregionInvestiment do
  subject(:contract) { build(:integration_macroregions_macroregion_investiment) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_macroregions_macroregion_investiment, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ano_exercicio).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_poder).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_poder).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:valor_lei).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_lei_creditos).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago).of_type(:decimal) }
      it { is_expected.to have_db_column(:perc_empenho).of_type(:decimal) }
      it { is_expected.to have_db_column(:perc_pago).of_type(:decimal) }
      it { is_expected.to have_db_column(:perc_pago_calculated).of_type(:decimal) }

      it { is_expected.to have_db_column(:power_id).of_type(:integer) }
      it { is_expected.to have_db_column(:region_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:ano_exercicio, :codigo_poder, :codigo_regiao]) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:power) }
    it { is_expected.to belong_to(:region) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ano_exercicio) }
    it { is_expected.to validate_presence_of(:codigo_poder) }
    it { is_expected.to validate_presence_of(:codigo_regiao) }

    it { is_expected.to validate_uniqueness_of(:ano_exercicio).scoped_to(:codigo_poder, :codigo_regiao).case_insensitive }
  end

  describe 'callbacks' do
    it 'set_perc_pago_calculated' do
      investment = build(:integration_macroregions_macroregion_investiment)
      investment.save

      expected = (investment.valor_pago / investment.valor_lei) * 100

      expect(investment.reload.perc_pago_calculated).to eq(expected)
    end
  end
end
