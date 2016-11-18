FactoryGirl.define do
  factory :community do
    sequence(:name) { |n| "Сообщество #{n}" }
  end
end
