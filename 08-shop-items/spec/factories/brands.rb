FactoryGirl.define do
  factory :brand do
    sequence(:name) { |n| "Производитель #{n}" }
  end
end
