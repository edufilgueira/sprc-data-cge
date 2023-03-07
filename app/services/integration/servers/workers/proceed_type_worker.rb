class Integration::Servers::Workers::ProceedTypeWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def perform(line, attributes, args = nil)
    attributes['cod_provento'] = attributes['cod_provento'].rjust(5, "0")
    resource = klass.find_or_initialize_by(cod_provento: attributes['cod_provento'],
      origin: attributes['origin'])
    resource.update_attributes(attributes)
  end

  private

  def klass
    Integration::Servers::ProceedType
  end
end
