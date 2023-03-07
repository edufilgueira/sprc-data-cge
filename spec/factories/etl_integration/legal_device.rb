FactoryBot.define do
  factory :etl_integration_legal_device, class: 'EtlIntegration::LegalDevice' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
