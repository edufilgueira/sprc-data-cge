require 'rails_helper'

describe Integration::Purchases::Purchase do
  subject(:integration_purchases_purchase) { build(:integration_purchases_purchase) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_purchases_purchase, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:numero_publicacao).of_type(:string) }
      it { is_expected.to have_db_column(:numero_viproc).of_type(:string) }
      it { is_expected.to have_db_column(:num_termo_participacao).of_type(:string) }
      it { is_expected.to have_db_column(:cnpj).of_type(:string) }
      it { is_expected.to have_db_column(:nome_resp_compra).of_type(:string) }
      it { is_expected.to have_db_column(:uf_resp_compra).of_type(:string) }
      it { is_expected.to have_db_column(:macro_regiao_org).of_type(:string) }
      it { is_expected.to have_db_column(:micro_regiao_org).of_type(:string) }
      it { is_expected.to have_db_column(:municipio_resp_compra).of_type(:string) }
      it { is_expected.to have_db_column(:cpf_cnpj_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:nome_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:uf_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:macro_regiao_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:micro_regiao_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:municipio_fornecedor).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_material_servico).of_type(:string) }
      it { is_expected.to have_db_column(:nome_grupo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_item).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_item).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_fornecimento).of_type(:string) }
      it { is_expected.to have_db_column(:marca).of_type(:string) }
      it { is_expected.to have_db_column(:natureza_aquisicao).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_aquisicao).of_type(:string) }
      it { is_expected.to have_db_column(:sistematica_aquisicao).of_type(:string) }
      it { is_expected.to have_db_column(:forma_aquisicao).of_type(:string) }
      it { is_expected.to have_db_column(:tratamento_diferenciado).of_type(:boolean) }
      it { is_expected.to have_db_column(:data_publicacao).of_type(:datetime) }
      it { is_expected.to have_db_column(:quantidade_estimada).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_unitario).of_type(:decimal) }
      it { is_expected.to have_db_column(:data_finalizada).of_type(:datetime) }
      it { is_expected.to have_db_column(:valor_total_melhor_lance).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_estimado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_total_estimado).of_type(:decimal) }
      it { is_expected.to have_db_column(:aquisicao_contrato).of_type(:boolean) }
      it { is_expected.to have_db_column(:prazo_entrega).of_type(:string) }
      it { is_expected.to have_db_column(:prazo_pagamento).of_type(:string) }
      it { is_expected.to have_db_column(:exige_amostras).of_type(:string) }
      it { is_expected.to have_db_column(:data_carga).of_type(:datetime) }
      it { is_expected.to have_db_column(:ano).of_type(:string) }
      it { is_expected.to have_db_column(:mes).of_type(:string) }
      it { is_expected.to have_db_column(:ano_mes).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_classe_material).of_type(:string) }
      it { is_expected.to have_db_column(:nome_classe_material).of_type(:string) }
      it { is_expected.to have_db_column(:registro_preco).of_type(:string) }
      it { is_expected.to have_db_column(:unid_compra_regiao_planej).of_type(:string) }
      it { is_expected.to have_db_column(:fornecedor_regiao_planejamento).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:grupo_lote).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_item_referencia).of_type(:string) }
      it { is_expected.to have_db_column(:id_item_aquisicao).of_type(:integer) }
      it { is_expected.to have_db_column(:cod_item_referencia).of_type(:string) }
      it { is_expected.to have_db_column(:valor_total_calculated).of_type(:decimal) }

      it { is_expected.to have_db_column(:manager_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # TODO: check witch columns
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:manager).class_name('Integration::Supports::ManagementUnit') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :numero_publicacao }
    it { is_expected.to validate_presence_of :numero_viproc }
    it { is_expected.to validate_presence_of :num_termo_participacao }
    it { is_expected.to validate_presence_of :codigo_item }
  end

  describe 'scopes' do
    it 'active_on_month' do
      now = DateTime.now

      purchase_data = { data_publicacao: now }
      active = create(:integration_purchases_purchase, purchase_data)

      purchase_data = { data_publicacao: now - 1.month }
      inactive = create(:integration_purchases_purchase, purchase_data)

      date = now.to_date

      expect(Integration::Purchases::Purchase.active_on_month(date)).to eq([active])
    end
  end

  describe 'callbacks' do
    it 'set_valor_total_calculated' do
      purchase = build(:integration_purchases_purchase)
      purchase.save

      expected = purchase.quantidade_estimada.to_f * purchase.valor_unitario.to_f

      expect(purchase.reload.valor_total_calculated).to eq(expected)
    end
  end
end
