require 'rails_helper'

describe Api::V1::Publications::ConvenantsController do

	let(:convenant_confidential) { create(:integration_contracts_convenant, :with_nesteds, confidential: true) }
	let(:convenant_not_confidential) { create(:integration_contracts_convenant, :with_nesteds, confidential: false) }
	let(:attributes_confidential_list) { { descricao_url: nil, descricao_url_pltrb: nil, descricao_url_ddisp: nil, descricao_url_inexg: nil } }
	let(:work_plan) { create(:integration_eparcerias_work_plan_attachment, isn_sic: convenant_not_confidential.isn_sic ) }
	let(:obt) { create(:integration_eparcerias_transfer_bank_order, isn_sic: convenant_not_confidential.isn_sic ) }

	describe 'confidential'  do
		before { 
			convenant_not_confidential 
			convenant_confidential
		}

		
	  describe 'turn on'  do

	  	it 'resource found' do

	      get(:turn_on_confidential, params: { 
	      	isn_sic: convenant_not_confidential.isn_sic 
	      }, as: :json) 

	 			convenant_not_confidential.reload

	      result = {  
	      	id: convenant_not_confidential.id, 
	    		confidential: convenant_not_confidential.confidential 
	      }.to_json

	      expect(response.body).to eq(result)
	      expect(convenant_not_confidential.confidential).to eq(true)

	      # Campos que devem ser apagados ao se tornar confidencial/sigiloso
	      expect(
	      	convenant_not_confidential.attributes.slice(
	      		 	'descricao_url',
	      		 	'descricao_url_pltrb',
	      		  'descricao_url_ddisp', 
	      		  'descricao_url_inexg'
	      		)
	      	).to eq(attributes_confidential_list.stringify_keys)

	      # Verifica se apagou anexo aditivo
	      expect(convenant_not_confidential.additives).to eq(
	      	convenant_not_confidential.additives.where(descricao_url: nil)
	      )

	      # Verifica se apagou plano de trabalho
	      expect(convenant_not_confidential.work_plan_attachments.count).to eq(0)

	      # Verifica se apagou anexo ajustes
	      expect(convenant_not_confidential.adjustments).to eq(
	      	convenant_not_confidential.adjustments.where(descricao_url: nil)
	      )

	      # Remove OBTs
				expect(convenant_not_confidential.transfer_bank_orders.count).to eq(0)

	    end  

	    it 'resource not found'  do

	  		get(:turn_on_confidential, params: { isn_sic: 999 }, as: :json) 

	  		result_not_found = { 
	  			error: "Resource not found with isn_sic: 999" 
	  		}.to_json

	  		expect(response.body).to eq(result_not_found)
	  	end
	  end

	  describe 'turn off'  do
	  	it 'resource found' do

	      get(:turn_off_confidential, params: { 
	      	isn_sic: convenant_confidential.isn_sic 
	      }, as: :json) 

	 			convenant_confidential.reload

	      result = {  
	      	id: convenant_confidential.id, 
	    		confidential: convenant_confidential.confidential 
	      }.to_json

	      expect(response.body).to eq(result)
	      expect(convenant_confidential.confidential).to eq(false)
	    end  

	    it 'resource not found'  do

	  		get(:turn_off_confidential, params: { isn_sic: 999 }, as: :json) 

	  		result_not_found = { 
	  			error: "Resource not found with isn_sic: 999" 
	  		}.to_json

	  		expect(response.body).to eq(result_not_found)
	  	end
	  end
  end
end
