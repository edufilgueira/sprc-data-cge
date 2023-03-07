FactoryBot.define do
  factory :integration_ppa_source_region_configuration, class: 'Integration::PPA::Source::Region::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    operation 'regioes'
    response_path 'regioes_response/lista_regioes/regioes'
    status 1
    last_importation '2018-06-07 12:24:56'
    log 'MyText'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
