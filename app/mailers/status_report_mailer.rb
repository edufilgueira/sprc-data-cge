class StatusReportMailer < ApplicationMailer
	default to: 'cttecnico@cge.ce.gov.br'

	helper_method :status_color, :time_parser

	SUBJECT = "Integrações Status Report:"

  # No futuro o ideal seria ter uma tabela
  # para admininstrar recipients por tipo de mailer

  def integrations(recipient, array_hash_result)
		@array_hash_result = array_hash_result
   
    mail(
      to: recipient, 
      from: smtp_settings[:from], 
      subject: subject(array_hash_result)
    )
    
  end
  
  private

  def subject(result)
  	"#{SUBJECT} #{subject_status(result)}"
  end

  def subject_status(result)
  	if has_error_in_result?(result)
  		"Erro"
  	else
  		"Sucesso"
  	end
  end

  def has_error_in_result?(result)
  	for item in result
			return true if status_fail(item['status'])
		end
		false
  end

  def status_color(status)
  	return "red" if status_fail(status)
  	return "green" if status_sucess(status)
  	
  	"blue"
  end

  def status_fail(status)
  	status == "status_fail"
  end

  def status_sucess(status)
  	status == "status_success"
  end

  def time_parser(time)
  	return "" unless time.present? 
    
  	time.to_datetime.strftime('%d/%m/%Y %H:%M')
  end

  def recipients
    RECIPIENTS
  end
end