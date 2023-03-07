require 'rails_helper'

describe Api::V1::Publications::AdditivesController do

  let(:resource_params) { build(:integration_contracts_additive).attributes }
  let(:invalid_resource_params) { build(:integration_contracts_additive, :invalid).attributes }
  let(:klass_model) { Integration::Contracts::Additive }
  let(:contract_model) { Integration::Contracts::Contract }
  let(:response_error) { {"data_aditivo":["não pode ficar em branco"]}.to_json }
  let(:response_error2) { {"isn_sic":["não é válido"]}.to_json }

  describe '#create'  do
    describe 'contract' do
      describe 'valid' do
        

        it 'publish'  do
          expect do
            post(:create, params: resource_params, as: :json) 
            expect(response.body).to eq({ id: klass_model.last.id }.to_json)

          end.to(change { klass_model.count }.by(1))
        end

        it 're-publish same item n times'  do
          expect do

            3.times do 
              post(:create, params: resource_params, as: :json) 
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

        it 'publish without valid contract (isn sic)'  do
          expect do
            resource_params[:isn_sic] = '99999'
            post(:create, params: resource_params, as: :json) 
            expect(response.body).to eq(response_error2)

          end.to(change { klass_model.count }.by(0))
        end
      end
    end
  end

   describe '#destroy'  do
    describe 'valid' do
 
      it 'additive' do
        expect do
          resource = create(:integration_contracts_additive) 
          delete(:destroy, params: { isn_contrato_aditivo: resource.isn_contrato_aditivo }, as: :json) 
          
        end.to(change { klass_model.count }.by(0))
      end

      it 'with contract ' do

        adjustment = create(:integration_contracts_additive) 
        delete(:destroy, params: { isn_contrato_aditivo: adjustment.isn_contrato_aditivo }, as: :json) 

        expect(response.body).to eq({ status: 'item destroyed' }.to_json)
        expect(klass_model.count).to eq(0)
        expect(contract_model.count).to eq(1) # o crontato nao deve ser apagado
      end
    end

    describe 'invalid' do
      
      it 'additive' do
   
        expect do
          resource = create(:integration_contracts_additive) 
            
          delete(:destroy, params: { isn_contrato_aditivo: 999 }, as: :json) 
          expect(response.body).to eq({  status: 'item not found' }.to_json)
        end.to(change { klass_model.count }.by(1))
      end
    end
  end
end