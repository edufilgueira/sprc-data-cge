FactoryBot.define do
  factory :etl_integration_government_action, class: 'EtlIntegration::GovernmentAction' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
