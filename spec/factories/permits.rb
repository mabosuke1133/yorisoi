FactoryBot.define do
  factory :permit do
    association :user
    association :group
    status { "approved" } # 最初から承認済みとして作成
  end
end