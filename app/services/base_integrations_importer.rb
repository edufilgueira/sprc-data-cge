module BaseIntegrationsImporter
  include LogImporter

  TIMEOUTS = {
    'test': { open: 1.second, read: 2.second },
    'development': { open: 20.seconds, read: 5.minutes },
    'production': { open: 5.minutes, read: 20.minutes }
  }

  PROXIES = {

  }

  def client_connection(wsdl, headers_soap_action, clear_empty_soap_action = false)
    enviroment = Rails.env.to_sym

    params = {
      wsdl: wsdl,

      #
      # Para testar as integrações de webservices em desolvimento,
      # 1) siga as instruções em: https://github.com/caiena/sprc/wiki/Tunelamento-e-atualiza%C3%A7%C3%A3o-de-reposit%C3%B3rio-externo
      # 2) use a versão do savon (Gemfile)
      # 3) descomente a linha do proxy abaixo
      #
      # Além disso, use a versão do Savon que suporte proxies, pois a versão
      # ~ 2.0.0 não suporta. (ver Gemfile)
      #

      read_timeout: TIMEOUTS[enviroment][:read],
      open_timeout: TIMEOUTS[enviroment][:open]
    }

    if PROXIES[enviroment].present?
      params[:proxy] = PROXIES[enviroment]
    end

    # Não podemos adicionar o header em branco, os serviços ficam falhando:
    # System.Web.Services.Protocols.SoapException: Server did not recognize the value of HTTP Header SOAPAction: .

    if headers_soap_action.present?
      # Também não podemos passar a operation como action pois:
      # # (soap:Server) The given SOAPAction consultaContratosConvenios does not match an operation.
      # (soap:Server) The given SOAPAction consultaContratosConvenios does not match an operation.
      params[:headers] = { 'SOAPAction' => headers_soap_action }
    elsif ! clear_empty_soap_action
      #
      # Os serviços de despesas, quebram se SOAPAction não for ''
      #
      params[:headers] = { 'SOAPAction' => '' }
    end

    Savon.client(params)
  end

  def update(resource, attributes, line)
    begin
      update! resource, attributes
    rescue => err
      log(:error, I18n.t('services.importer.log.validation_fail', line: line, error: resource.errors.full_messages.to_sentence))
    end
  end

  def update!(resource, attributes)
    safe_assign_attributes(resource, attributes)
    resource.save!
  end

  def resources(prefix=nil)
    result_array = response_path(prefix).inject(body(prefix)) do |result, key|
      next if result.nil?

      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def ensure_resource_type(result)
    array = result.is_a?(Array) ? result : (result.present? ? [result] : [])

    array.compact
  end

  def response(prefix=nil)
    # o prefix é usado em alguns importers como revenues, ...
    service_message = (prefix.present? ? message(prefix) : message)

    # advanced_typecasting: false evita que as datetimes sejam convertidas com timezone errado.
    @client.call(operation(prefix), advanced_typecasting: false, message: service_message)
  end

  def default_message
    {
      usuario: @configuration.user,
      senha: @configuration.password
    }
  end

  def response_path(prefix=nil)
    # o prefix é usado em alguns importers como revenues, ...

    if (prefix.present?)
      @configuration.send("#{prefix}_response_path")
    else
      @configuration.response_path
    end.split('/').map(&:to_sym)
  end

  def body(prefix=nil)
    # o prefix é usado em alguns importers como revenues, ...
    selected_response = (prefix.present? ? response(prefix) : response)

    return selected_response.try(:body) if selected_response.present?

    {}
  end

  def operation(prefix=nil)
    if prefix.present?
      @configuration.send("#{prefix}_operation")
    else
      @configuration.operation
    end.to_sym
  end

  def safe_strip(attribute)
    (attribute || '').strip
  end

  def safe_assign_attributes(resource, attributes)
    #
    # Temos que garantir que se houver adição de colunas no webservice, o
    # importador não irá falhar ao tentar atribuir seu valor, como quando usado
    # o update_attributes, ou o assign_attributes.
    #
    attributes.each do |name, value|
      if resource.respond_to?("#{name}=")
        resource.send("#{name}=", value)
      end
    end
  end
end
