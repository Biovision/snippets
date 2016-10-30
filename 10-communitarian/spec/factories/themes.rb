FactoryGirl.define do
  factory :theme do
    sequence(:name) { |n| "Тема #{n}" }
    sequence(:slug) { |n| "theme-#{n}" }
  end
end
