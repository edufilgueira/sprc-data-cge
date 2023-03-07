require 'rails_helper'

describe Api::V1::Publications::ContractsController do
  
  let(:resource_params) { build(:integration_contracts_contract).attributes }
  let(:convenant_confidential_params) { build(:integration_contracts_convenant, confidential: true).attributes }
  let(:invalid_resource_params) { build(:integration_contracts_contract, :invalid).attributes }
  let(:klass_model) { Integration::Contracts::Contract }
  let(:convenant_model) { Integration::Contracts::Convenant }
  let(:additive_model) { Integration::Contracts::Additive }
  let(:adjustment_model) { Integration::Contracts::Adjustments }
  let(:response_error) { {"data_assinatura":["não pode ficar em branco"]}.to_json }
  let(:now) { DateTime.now }
  let(:attributes_confidential_list) { { descricao_url: nil, descricao_url_pltrb: nil, descricao_url_ddisp: nil, descricao_url_inexg: nil } }

  describe '#create'  do
    describe 'valid' do
      it 'publish'  do

      	expect do
          post(:create, params: { contract: resource_params }, as: :json) 
          expect(response.body).to eq({ id: klass_model.last.id }.to_json)
      	end.to(change { klass_model.count }.by(1))
    	end

      it 'publish with new fields'  do
        expect do
          new_fields = {
            data_termino_original: now,
            data_rescisao: now,
            data_inicio: now
          }

          post(:create, params: { contract: resource_params.merge(new_fields) }, as: :json) 
          resource =  klass_model.last
          
          # o timezone atrapalha a comparação, por isso usei to_s :short
          expect(resource.data_termino_original.to_s(:short)).to eq(now.to_s(:short)) 
          expect(resource.data_rescisao.to_s(:short)).to eq(now.to_s(:short))
          expect(resource.data_inicio.to_s(:short)).to eq(now.to_s(:short))
          expect(response.body).to eq({ id: resource.id }.to_json)
          
        end.to(change { klass_model.count }.by(1))
      end

      it 're publish same item without duplicate'  do
        expect do
          3.times do 
            post(:create, params: { contract: resource_params }, as: :json) 
          end
          
        end.to(change { klass_model.count }.by(1))
      end

      it 'publish a confidential convenant' do
        expect do
          post(:create, params: { contract: convenant_confidential_params }, as: :json) 

          expect(response.body).to eq({ id: convenant_model.last.id }.to_json)
          expect(convenant_model.last.confidential).to eq(true)

          expect(
            convenant_model.last.attributes.slice(
              'descricao_url',
              'descricao_url_pltrb',
              'descricao_url_ddisp', 
              'descricao_url_inexg'
            )
          ).to eq(attributes_confidential_list.stringify_keys)

        end.to(change { convenant_model.count }.by(1))
      end
    end
    describe 'invalid' do
      it 'publish'  do
        expect do
          post(:create, params: { contract:  invalid_resource_params }, as: :json) 
          expect(response.body).to eq(response_error)
        end.to(change { klass_model.count }.by(0))
      end
    end    
  end

  describe '#destroy'  do
    describe 'valid' do
      it 'contract' do
        expect do
          resource = create(:integration_contracts_contract) 
          
          delete(:destroy, params: { isn_sic: resource.isn_sic }, as: :json) 
        end.to(change { klass_model.count }.by(0))
      end

      it 'convenant' do
        expect do
          resource = create(:integration_contracts_convenant) 
          delete(:destroy, params: { isn_sic: resource.isn_sic }, as: :json) 
        end.to(change { convenant_model.count }.by(0))
      end

      it 'contract with adictive' do
        additive = create(:integration_contracts_additive) 
        resource = additive.contract

        delete(:destroy, params: { isn_sic: resource.isn_sic }, as: :json) 

        expect(response.body).to eq({ status: 'item destroyed' }.to_json)
        expect(klass_model.count).to eq(0)
        expect(additive_model.count).to eq(0)
      end
    end

    describe 'invalid' do
      it 'contract' do
        expect do
          resource = create(:integration_contracts_contract) 
          delete(:destroy, params: { isn_sic: 999 }, as: :json) 
          expect(response.body).to eq({  status: 'item not found' }.to_json)
        end.to(change { klass_model.count }.by(1))
      end
    end
  end
end