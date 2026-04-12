FactoryBot.define do
  factory :group_message do
    body { "テストメッセージです" }
    association :user
    association :group
  end
end