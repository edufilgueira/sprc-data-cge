FactoryBot.define do
  factory :integration_utils_data_change, class: 'Integration::Utils::DataChange' do
    data_changes ""
    changeable_id 1
    changeable_type 'Integration::Constructions::Dae'

    trait :invalid do
      changeable_id nil
    end
  end
end
