FactoryBot.define do
  factory :etl_integration_expense_nature_group, class: 'EtlIntegration::ExpenseNatureGroup' do
    codigo { '001' }
    titulo { 'Titulo' }
  end
end
