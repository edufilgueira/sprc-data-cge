namespace :ops do

  #
  # cd /app/sprc-data/current && RAILS_ENV=production bundle exec rake ops:fix_organs
  #
  task fix_organs: :environment do

    organs = Integration::Supports::Organ.all

    configuration = Integration::Supports::Organ::Configuration.last

    client = Savon.client(wsdl: configuration.wsdl, log: true, logger: Rails.logger, read_timeout: 1000, open_timeout: 1000 , headers: { 'SOAPAction' => ''})

    response = client.call(:consulta_orgaos, message: { usuario: configuration.user, senha: configuration.password })

    organs_attributes = response.body[:consulta_orgaos_response][:lista_orgao][:orgao]

    #
    # XXX validação para garantir que o WS restornou a quantidade de registros esperados
    #
    if organs_attributes.count == 372
      counter = 0

      organs.each do |o|
        organ_attribute = response.body[:consulta_orgaos_response][:lista_orgao][:orgao].map do |c|
          if c[:codigo_orgao] == o.codigo_orgao && c[:descricao_orgao] == o.descricao_orgao && c[:sigla] == o.sigla && c[:sigla] == o.sigla && c[:descricao_entidade] == o.descricao_entidade && c[:descricao_administracao] == o.descricao_administracao && c[:poder] == o.poder && c[:codigo_folha_pagamento] == o.codigo_folha_pagamento && c[:data_inicio]&.to_date == o.data_inicio && c[:data_termino]&.to_date == o.data_termino && c[:orgao_sfp] == o.orgao_sfp
            o
          end
        end.compact

        if organ_attribute.blank?
          counter += 1

          puts "[Órgão #{o.id}] - PARA SER REMOVIDO OU ATUALIZAR A RELAÇÃO"

          # XXX testar antes de destruir os órgãos duplicados
          begin
            if o.destroy
              puts "[Órgão #{o.id}] - REMOVIDO"
            end
          rescue => err
            puts "[Órgão #{o.id}] - TEM CHAVE ESTRANGEIRA"
            update_transparency(o)
          end
        else
          puts "[Órgão #{o.id}] - IDÊNTICO AO DO SERVIÇO"
        end
      end

      puts "Orgãos a serem removidos: #{counter}"
    end
  end

  def update_transparency(organ)
    strategic_indicators = Integration::Results::StrategicIndicator.unscoped.where(organ: organ)
    strategic_indicators.each { |s| update_organ(s, 'organ_id') }

    thematic_indicators = Integration::Results::ThematicIndicator.unscoped.where(organ: organ)
    thematic_indicators.each { |t| update_organ(t, 'organ_id') }

    city_undertakings = Integration::CityUndertakings::CityUndertaking.unscoped.where(organ: organ)
    city_undertakings.each { |c| update_organ(c, 'organ_id') }

    daes = Integration::Constructions::Dae.unscoped.where(organ: organ)
    daes.each { |d| update_organ(d, 'organ_id') }

    daes = Integration::RealStates::RealState.unscoped.where(manager: organ)
    daes.each { |d| update_organ(d, 'manager_id') }
  end

  def update_organ(resource, sym)
    old_organ = Integration::Supports::Organ.find(resource.send(sym))
    organs_related = Integration::Supports::Organ.where(codigo_orgao: old_organ.codigo_orgao, data_termino: old_organ.data_termino, codigo_folha_pagamento: old_organ.codigo_folha_pagamento)

    if organs_related.count == 1
      organs_related = Integration::Supports::Organ.where(codigo_orgao: old_organ.codigo_orgao, codigo_folha_pagamento: old_organ.codigo_folha_pagamento)
    end

    if organs_related.count >= 1
      new_organ = organs_related.count == 1 ? organs_related.first : organs_related.select { |o| o != old_organ }.last

      if new_organ.present?
        resource.send("#{sym}=", new_organ)
        resource.save!

        puts "Atualizou a relação #{resource.class.name}: #{old_organ.id} para #{new_organ.id}"
      end
    end
  end
end
