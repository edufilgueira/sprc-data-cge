require 'rails_helper'

Rails.application.load_tasks

describe 'Change to confidential' do
  describe 'Convenants' do
   
    let(:arg1) {"123456"}
    let(:convenant_model) { Integration::Contracts::Convenant }
    let(:obt_model) { Integration::Eparcerias::TransferBankOrder }

    before {
      
      create(:integration_contracts_convenant, isn_sic: '123456')
      create(:integration_eparcerias_transfer_bank_order, isn_sic: '123456', convenant: convenant_model.first)
      create(:integration_eparcerias_work_plan_attachment, isn_sic: '123456', convenant: convenant_model.first)
      create(:integration_contracts_additive, isn_sic: '123456', convenant: convenant_model.first)
      create(:integration_contracts_adjustment, isn_sic: '123456', convenant: convenant_model.first)
    }

    it "Change convenant confidential" do
      convenant = convenant_model.first

      expect(convenant.confidential).not_to eq(true)
      expect(convenant.transfer_bank_orders.count).to eq(1)
      expect(convenant.work_plan_attachments.count).to eq(1)
      expect(convenant.additives.count).to eq(1)
      expect(convenant.additives.first.descricao_url).not_to be(nil)
      expect(convenant.adjustments.count).to eq(1)
      expect(convenant.adjustments.first.descricao_url).not_to be(nil)
      

      Rake::Task["integration:contracts:change_confidential"].invoke(arg1)
      
      convenant.reload
      expect(convenant_model.count).to eq(1)
      expect(convenant.confidential).to eq(true)
      expect(convenant.transfer_bank_orders.count).to eq(0)
      expect(convenant.descricao_url).to be(nil)
      expect(convenant.descricao_url_pltrb).to be(nil)
      expect(convenant.descricao_url_ddisp).to be(nil)
      expect(convenant.descricao_url_inexg).to be(nil)
      expect(convenant.work_plan_attachments.count).to eq(0)
      expect(convenant.additives.first.descricao_url).to be(nil)
      expect(convenant.adjustments.first.descricao_url).to be(nil)
      
    end

  end
end


