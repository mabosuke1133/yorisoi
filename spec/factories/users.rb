FactoryBot.define do
  factory :user do
    name { "テスト太郎" }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
end