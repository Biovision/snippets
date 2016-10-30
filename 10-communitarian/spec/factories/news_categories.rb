FactoryGirl.define do
  factory :news_category do
    sequence(:name) { |n| "Категория новостей #{n}" }
  end
end
