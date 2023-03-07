class Integration::Servers::Workers::RegistrationWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def perform(line, attributes, args = nil)

    # Não podemos fazer a associação direta com Server pois eles são criados
    # a partir de registration e precisamos tentar encontrar/inicializar de
    # qualquer forma.
    server = Integration::Servers::Server.find_or_initialize_by(server_finder(attributes))
    servers_import(server, attributes)

    registration = Integration::Servers::Registration.find_or_initialize_by(registration_finder(attributes))
    registration.update_attributes(attributes)

  end

  private

  def klass
    Integration::Servers::Registration
  end

  def server_finder(attributes)
    {
      dsc_cpf: attributes['dsc_cpf']
    }
  end

  def registration_finder(attributes)
    {
      dsc_matricula: attributes['dsc_matricula'],
      cod_orgao: attributes['cod_orgao']
    }
  end

  def servers_import(server, attributes)
    server.dsc_cpf = attributes['dsc_cpf']
    server.dsc_funcionario = attributes['dsc_funcionario']
    server.dth_nascimento = attributes['dth_nascimento']
    server.save
  end
end
