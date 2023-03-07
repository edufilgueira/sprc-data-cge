FactoryBot.define do
  factory :integration_ppa_source_guideline_configuration, class: 'Integration::PPA::Source::Guideline::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl'
    headers_soap_action ''
    user 'caiena'
    year 2018
    password '-'
    operation 'listagem_diretrizes'
    response_path 'listagem_diretrizes_response/lista_diretrizes/diretriz'
    status 1
    last_importation '2018-06-06 18:14:35'
    log 'MyText'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
