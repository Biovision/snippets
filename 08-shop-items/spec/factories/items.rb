FactoryGirl.define do
  factory :item do
    category
    item_type
    sequence(:name) { |n| "Товар #{n}" }
  end
end
