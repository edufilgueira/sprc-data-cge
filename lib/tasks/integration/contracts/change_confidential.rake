namespace :integration do
  namespace :contracts do
  	desc "Marca Contratos como sigilosos e realiza higiencização de dados"

  	task :change_confidential, [:isn_sic] => :environment do |t, args|
  		isn_sic = args.isn_sic.to_i

  		resource = get_resource(isn_sic)
  		update_confidential_flag(resource)
  		remove_obts(resource)
  		remove_instrument_document(resource) #integra/descricao_url
  		remove_work_plan_attachments(resource)
  		remove_additive_document(resource) #integra/descricao_url
  		remove_adjustments_document(resource) 
  	end
  end
end

def get_resource(isn_sic)
	resource = get_contract(isn_sic) || get_convenant(isn_sic)
	return raise "Resource not fount for isn_sic: #{isn_sic}" if !resource.present?
		
	resource
end

def get_contract(isn_sic)
	contract_model.find_by_isn_sic(isn_sic)
end

def get_convenant(isn_sic) 
	convenant_model.find_by_isn_sic(isn_sic)
end

def contract_model
	Integration::Contracts::Contract
end

def convenant_model
	Integration::Contracts::Convenant
end

def update_confidential_flag(resource)
	resource.update(confidential: true)  		
end

def remove_obts(resource)
	resource.transfer_bank_orders.delete_all
end

# Remove Integra do instrumento / descricao_url
def remove_instrument_document(resource)
	# "descricao_url", "descricao_url_pltrb", "descricao_url_ddisp", "descricao_url_inexg"
	resource.update(descricao_url: nil, descricao_url_pltrb: nil, descricao_url_ddisp: nil, descricao_url_inexg: nil)
end

def remove_work_plan_attachments(resource)
	resource.work_plan_attachments.destroy_all
end

def remove_additive_document(resource)
	resource.additives.update_all(descricao_url: nil)
end

def remove_adjustments_document(resource)
	resource.adjustments.update(descricao_url: nil)
end