FactoryBot.define do
  factory :etl_integration_government_program, class: 'EtlIntegration::GovernmentProgram' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
