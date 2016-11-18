FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "Клиент #{n}" }
  end
end
