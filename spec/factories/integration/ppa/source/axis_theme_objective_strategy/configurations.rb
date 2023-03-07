FactoryBot.define do
  factory :integration_ppa_source_axis_theme_objective_strategy_configuration, class: 'Integration::PPA::Source::AxisThemeObjectiveStrategy::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    operation 'estrategias_regionais'
    response_path 'eixos_temas_response/lista_eixos_temas/eixos_temas'
    status 1
    last_importation '2018-06-06 18:14:26'
    log 'MyText'
    year 2020

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
