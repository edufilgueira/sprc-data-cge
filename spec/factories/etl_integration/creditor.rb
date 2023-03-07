FactoryBot.define do
  factory :etl_integration_creditor, class: 'EtlIntegration::Creditor' do
    codigo { '001' }
    nome { 'Titulo' }
  end
end
