FactoryBot.define do
  factory :integration_ppa_source_axis_theme_configuration, class: 'Integration::PPA::Source::AxisTheme::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    operation 'eixos_temas'
    response_path 'eixos_temas_response/lista_eixos_temas/eixos_temas'
    status 1
    last_importation '2018-06-06 18:14:26'
    log 'MyText'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
