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

  has_many :permits, dependent: :destroy

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

  # フォローを行う側の関係性（自分から相手へ）
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされる側の関係性（相手から自分へ）
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 自分がいまフォローしている人たち（active_relationships を経由して followed を取得）
  has_many :followings, through: :active_relationships, source: :followed
  # 自分をフォローしてくれている人たち（passive_relationships を経由して follower を取得）
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定したユーザーをフォローするメソッド
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除するメソッド
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをすでにフォローしているか確認するメソッド
  def following?(user)
    followings.include?(user)
  end

  # 💡 タイムライン用のメソッド
  def feed
    # 自分がフォローしている人たちのIDを配列で取得
    # [1, 3, 5] のような形式になる
    following_ids = self.followings.pluck(:id)
    
    # 💡 「フォローしている人のID」に「自分のID」を合流させる
    # Post.where(user_id: [1, 3, 5, 自分のID]) という条件で検索
    Post.where(user_id: following_ids << self.id)
  end

  # 💡 自分がオーナー（作った人）であるグループ
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :destroy

  # 💡 自分がメンバーとして「承認済み」のグループ
  has_many :approved_permits, -> { where(status: :approved) }, class_name: 'Permit'
  has_many :participating_groups, through: :approved_permits, source: :group
end
