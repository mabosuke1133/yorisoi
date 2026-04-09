FactoryBot.define do
  factory :admin do
    # sequence を使うことで admin1@..., admin2@... と毎回違うメアドになる
    sequence(:name) { |n| "管理者#{n}" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    invitation_code { "yorisoi0000" }
  end
end