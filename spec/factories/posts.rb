FactoryBot.define do
  factory :post do
    title { "広場の投稿タイトル" }
    body { "広場の投稿本文です。今日もお疲れ様です。" }
    emotion_level { 3 } 
    priority { :soliloquy }
    association :user  # Userモデルとの紐付け
  end
end