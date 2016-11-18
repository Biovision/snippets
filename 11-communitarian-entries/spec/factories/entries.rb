FactoryGirl.define do
  factory :entry do
    user
    body "Очередная публикация"

    factory :entry_for_community do
      privacy Entry.privacies[:visible_to_community]
    end

    factory :entry_for_followees do
      privacy Entry.privacies[:visible_to_followees]
    end

    factory :personal_entry do
      privacy Entry.privacies[:personal]
    end
  end
end
