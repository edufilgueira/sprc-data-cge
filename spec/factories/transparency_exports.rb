FactoryBot.define do
  factory :transparency_export, class: 'Transparency::Export' do
    name "Minha exportação do salário dos servidores"
    email "cidadao@example.com"
    query 'SELECT...'
    resource_name 'ModelName'
    filename ''
    expiration nil
    status nil
    worksheet_format 1

    trait :server_salary do
      query 'SELECT * FROM integration_servers_server_salaries'
      resource_name 'Integration::Servers::ServerSalary'
      filename "#{Time.now.to_i}_integration_servers_server_salary.csv"
    end

    trait :revenues_account do
      query 'SELECT * FROM integration_revenues_accounts'
      resource_name 'Integration::Revenues::Account'
      filename "#{Time.now.to_i}_integration_revenues_account.csv"
    end

    trait :invalid do
      email nil
    end
  end
end
