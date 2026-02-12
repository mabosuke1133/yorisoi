class Post < ApplicationRecord
  # ユーザーと投稿を紐付ける
  belongs_to :user

  # 空での投稿を禁止する
  validates :title, presence: true
  validates :body, presence: true
  validates :emotion_level, presence: true
end
