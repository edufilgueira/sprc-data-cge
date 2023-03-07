require 'rails_helper'

describe Api::V1::Publications::AdjustmentsController do

  let(:resource_params) { build(:integration_contracts_adjustment).attributes }
  let(:invalid_resource_params) { build(:integration_contracts_adjustment, :invalid).attributes }
  let(:response_error) { {"data_ajuste":["não pode ficar em branco"]}.to_json }
  let(:response_error2) { {"isn_sic":["não é válido"]}.to_json }
  let(:klass_model) { Integration::Contracts::Adjustment }
  let(:contract_model) { Integration::Contracts::Contract }

  describe '#create'  do
    describe 'valid' do

      it 'publish'  do
        expect do
          post(:create, params: resource_params, as: :json) 
          expect(response.body).to eq({ id: klass_model.last.id }.to_json)

        end.to(change { klass_model.count }.by(1))
      end

      it 're publish same item without duplicate'  do
        expect do
          3.times do 
            post(:create, params: resource_params , as: :json) 
          end
          
        end.to(change { klass_model.count }.by(1))
      end
    end

    describe 'invalid' do       	
 
      it 'publish'  do
        expect do
        
          post(:create, params: invalid_resource_params, as: :json) 
          expect(response.body).to eq(response_error)

        end.to(change { klass_model.count }.by(0))
      end

      it 'publish with invalid contract (isn sic)'  do
        expect do
          resource_params[:isn_sic] = '99999'
          post(:create, params: resource_params, as: :json) 
          expect(response.body).to eq(response_error2)

        end.to(change { klass_model.count }.by(0))
      end
    end
  end
  

  describe '#destroy'  do
    describe 'valid' do

      it 'adjustment' do
        expect do
          resource = create(:integration_contracts_adjustment) 
          
          delete(:destroy, params: { isn_contrato_ajuste: resource.isn_contrato_ajuste }, as: :json) 
        end.to(change { klass_model.count }.by(0))
      end

      it 'adjustment with contract ' do

        adjustment = create(:integration_contracts_adjustment) 
        delete(:destroy, params: { isn_contrato_ajuste: adjustment.isn_contrato_ajuste }, as: :json) 

        expect(response.body).to eq({ status: 'item destroyed' }.to_json)
        expect(klass_model.count).to eq(0)
        expect(contract_model.count).to eq(1) # o crontato nao deve ser apagado
      end
    end

    describe 'invalid' do
      
      it 'adjustment' do
   
        expect do
          resource = create(:integration_contracts_adjustment) 
            
          delete(:destroy, params: { isn_contrato_ajuste: 999 }, as: :json) 
          expect(response.body).to eq({  status: 'item not found' }.to_json)
        end.to(change { klass_model.count }.by(1))
      end
    end
  end
end
