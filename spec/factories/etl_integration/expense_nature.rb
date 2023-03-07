FactoryBot.define do
  factory :etl_integration_expense_nature, class: 'EtlIntegration::ExpenseNature' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
