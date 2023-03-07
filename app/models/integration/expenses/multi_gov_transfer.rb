#
# Representa 'Transferências a Instituições Multigovernamentais'
#
#
class Integration::Expenses::MultiGovTransfer < Integration::Expenses::Ned

	# Assossiations
	belongs_to :government_program,
    primary_key: :codigo_programa,
    foreign_key: :classificacao_programa_governo,
    class_name: 'Integration::Supports::GovernmentProgram'
    
  # Scope

  default_scope do
    where(transfer_type: :transfer_multi_govs)
  end
end
