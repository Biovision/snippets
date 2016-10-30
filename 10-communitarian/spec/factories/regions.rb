FactoryGirl.define do
  factory :region do
    sequence(:slug) { |n| "r#{n}" }
    sequence(:name) { |n| "Регион #{n}" }
  end
end
