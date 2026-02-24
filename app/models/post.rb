class Post < ApplicationRecord
  has_one_attached :image
  # ユーザーと投稿を紐付ける
  belongs_to :user

  # 空での投稿を禁止する
  validates :title, presence: true
  validates :body, presence: true
  validates :emotion_level, presence: true

  # 検索用メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?", "%#{word}%")
    else
      @post = Post.all
    end
  end
end
