namespace :integration do
  namespace :servers do
  
    task add_metrofor: :environment do

    	# puts  'Ajustando Orgão Metrofor para ser Folha de Pagamento'
    	Integration::Supports::Organ.find_by_sigla('METROFOR').update(codigo_folha_pagamento: '010', orgao_sfp: true)

    	# puts  'Ajustando tipo de proventos para SEPLAG'
    	Integration::Servers::ProceedType.update(origin: 0)

    	# ProceedType Duplicados
    	
    	duplicated_proceed_types = Integration::Servers::ProceedType.group(:cod_provento, :origin).having('count(*) > 1').count
    	duplicated_proceed_types.each do |item|
    		# item é assim: ["364", "seplag"]=>3

    		Integration::Servers::ProceedType.where(cod_provento: item[0][0], 
    			origin: item[0][1])
    			.limit(item[1]-1)
    			.each{ |proceed| proceed.destroy}
    	end    	
    end
  end
end