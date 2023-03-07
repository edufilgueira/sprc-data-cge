FactoryBot.define do
  factory :etl_integration_payment_retention_type, class: 'EtlIntegration::PaymentRetentionType' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end