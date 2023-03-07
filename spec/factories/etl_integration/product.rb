FactoryBot.define do
  factory :etl_integration_product, class: 'EtlIntegration::Product' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end