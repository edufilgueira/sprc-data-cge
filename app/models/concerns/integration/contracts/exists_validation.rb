# Concern criado para centralizar a validação de aditivos
# e apostilamentos, verificando se existe contrato vinculado
# na base do ct, evitando gravar orfãos

module Integration::Contracts::ExistsValidation
  extend ActiveSupport::Concern
  	
	included do
		validate :exists_contract_or_convenat?
	

		def exists_contract_or_convenat?
			unless Integration::Contracts::Contract.unscoped.where(isn_sic: self.isn_sic).exists?
				errors.add(:isn_sic, :invalid)
			end
		end  	
	end
end
