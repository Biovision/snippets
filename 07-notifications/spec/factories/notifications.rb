FactoryGirl.define do
  factory :notification do
    user
    category Notification.categories.values.first
  end
end
