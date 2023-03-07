class Integration::Servers::Workers::ProceedWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def perform(line, attributes, args = nil)
    klass.create(attributes)
  end

  private

  def klass
    Integration::Servers::Proceed
  end

  def proceeds_finder(attributes)
    {
      cod_provento: attributes['cod_provento'],
      cod_processamento: attributes['cod_processamento'],
      num_ano: attributes['num_ano'],
      num_mes: attributes['num_mes'],
      cod_orgao: attributes['cod_orgao'],
      dsc_matricula: attributes['dsc_matricula']
    }
  end
end
