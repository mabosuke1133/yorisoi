FactoryBot.define do
  factory :group do
    name { "ケア相談チーム" }
    introduction { "現場の悩みを共有するグループです。" }
    is_active { true }
    association :owner, factory: :user # 作成者(User)を自動生成
  end
end