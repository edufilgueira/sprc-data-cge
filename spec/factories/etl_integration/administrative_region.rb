FactoryBot.define do
  factory :etl_integration_administrative_region, class: 'EtlIntegration::AdministrativeRegion' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
