FactoryBot.define do
  factory :etl_integration_resource_source, class: 'EtlIntegration::ResourceSource' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end