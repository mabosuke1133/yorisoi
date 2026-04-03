class Post < ApplicationRecord
  has_one_attached :image
  # ユーザーと投稿を紐付ける
  belongs_to :user

  # 空での投稿を禁止する
  validates :title, presence: true
  validates :body, presence: true
  validates :priority, presence: true

  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum priority: { soliloquy: 1, hearing: 2, sos: 3 }

  # 引数で渡されたユーザidがfavoritesテーブル内に存在するかどうかを調べる
  def favorited_by?(user)
    # 💡 以下の1行を追加！ userがnil(空)なら、即座にfalseを返して終了する
    return false if user.nil?
    
    favorites.where(user_id: user.id).exists?
  end

  # 検索用メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      # 💡 title だけでなく body（本文）からも探せると、より検索しやすい
      where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      all
    end
  end
end
