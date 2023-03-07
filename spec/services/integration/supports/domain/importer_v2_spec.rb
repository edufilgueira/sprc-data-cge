require 'rails_helper'

describe Integration::Supports::Domain::ImporterV2 do

  let(:configuration) { create(:integration_supports_domain_configuration) }
  let(:service) { Integration::Supports::Domain::ImporterV2.new(configuration.id) }

  #Setup domain etl data
  let(:administrative_region) { create(:etl_integration_administrative_region) }
  let(:government_action) { create(:etl_integration_government_action) }
  let(:government_program) { create(:etl_integration_government_program) }
  let(:economic_category) { create(:etl_integration_economic_category) }  
  let(:function) { create(:etl_integration_function) }
  let(:sub_function) { create(:etl_integration_sub_function) }
  let(:product) { create(:etl_integration_product) }
  let(:resource_source) { create(:etl_integration_resource_source) }
  let(:legal_device) { create(:etl_integration_legal_device) }
  let(:expense_nature_group) { create(:etl_integration_expense_nature_group) }
  let(:expense_nature) { create(:etl_integration_expense_nature) }
  let(:revenue_nature) { create(:etl_integration_revenue_nature) }
  let(:application_modalitie) { create(:etl_integration_application_modalitie) }
  let(:payment_retention_type) { create(:etl_integration_payment_retention_type) }
  let(:creditor) { create(:etl_integration_creditor) }



  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Integration::Supports::Domain::ImporterV2).to receive(:new).with(1) { service }
      allow(service).to receive(:call)
      Integration::Supports::Domain::ImporterV2.call(1)
      expect(Integration::Supports::Domain::ImporterV2).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to configuration' do
      expect(service.configuration).to eq(configuration)
    end
  end

  describe 'imports' do
    
    before do
      #Setup domain etl data
      administrative_region
      government_action
      government_program
      economic_category      
      function
      sub_function
      resource_source
      expense_nature_group
      expense_nature
      revenue_nature
      application_modalitie
      payment_retention_type
      creditor      
      product      
      legal_device      

      service.call
      configuration.reload
    end

    describe 'Data domain' do
      it { 
        expect(Integration::Supports::AdministrativeRegion.count).to eq(1)
        expect(Integration::Supports::GovernmentAction.count).to eq(1)
        expect(Integration::Supports::GovernmentProgram.count).to eq(1)
        expect(Integration::Supports::EconomicCategory.count).to eq(1)        
        expect(Integration::Supports::Function.count).to eq(1)
        expect(Integration::Supports::SubFunction.count).to eq(1)       
        expect(Integration::Supports::ResourceSource.count).to eq(1)
        expect(Integration::Supports::ExpenseNatureGroup.count).to eq(1)
        expect(Integration::Supports::ExpenseNature.count).to eq(1)
        expect(Integration::Supports::RevenueNature.count).to eq(1)
        expect(Integration::Supports::ApplicationModality.count).to eq(1)
        expect(Integration::Supports::PaymentRetentionType.count).to eq(1)
        # expect(Integration::Supports::Creditor.count).to eq(1)
        expect(Integration::Supports::Product.count).to eq(1)
        expect(Integration::Supports::LegalDevice.count).to eq(1)
      }
    end
  end
end