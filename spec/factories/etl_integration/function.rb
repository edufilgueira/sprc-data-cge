FactoryBot.define do
  factory :etl_integration_function, class: 'EtlIntegration::Function' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end