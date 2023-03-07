FactoryBot.define do
  factory :etl_integration_economic_category, class: 'EtlIntegration::EconomicCategory' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end