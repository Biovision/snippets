FactoryGirl.define do
  factory :item_type do
    sequence(:name) { |n| "Тип товара #{n}" }
  end
end
