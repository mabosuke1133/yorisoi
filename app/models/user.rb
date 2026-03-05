class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :profile_image
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # dependent: :destroy をつけることで、退会時に投稿も一緒に消えます
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  # 自分がいいねした投稿を直接取得できるようにする
  has_many :favorite_posts, through: :favorites, source: :post

  # 検索用メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end
