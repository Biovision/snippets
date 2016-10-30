FactoryGirl.define do
  factory :post_category do
    sequence(:name) { |n| "Категория публикаций #{n}" }
  end
end
