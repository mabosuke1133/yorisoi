FactoryBot.define do
  factory :consultation do
    title { "相談のタイトル" }
    body { "相談の具体的な内容がここに入ります。" }
    status { :pending }
    association :user
  end
end