FactoryBot.define do
  factory :etl_integration_revenue_nature, class: 'EtlIntegration::RevenueNature' do
    codigo { '001' }
    titulo { 'Titulo' }
    ano { '2022' }
  end
end