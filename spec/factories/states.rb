FactoryBot.define do
  factory :state do
    sequence(:code)     { |n| n }
    sequence(:acronym)  { |n| "ST-#{n}" }
    sequence(:name)     { |n| "Estado #{n}" }

    trait :default do
      acronym 'CE'
      name 'Ceará'
    end
  end
end
