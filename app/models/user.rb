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

  has_many :issues, dependent: :destroy

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
  
  # --- 💡 フォロー機能の定義（自己参照リレーション） ---
  # フォローを行う側の関係性（自分から相手へ）
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされる側の関係性（相手から自分へ）
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 💡 活用：throughを経由することで「誰をフォロー中か」「誰がフォロワーか」を直感的な名前で取得可能に
  has_many :followings, through: :active_relationships, source: :followed
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

  # --- 💡 業務効率化：パーソナライズされた情報収集 ---
  def feed
    # フォロー中のスタッフIDを配列で抽出
    following_ids = self.followings.pluck(:id)
    
    # 💡 自分の投稿も含めた「自分に関係する全投稿」を一括検索し、情報の見落としを防ぐ
    Post.where(user_id: following_ids << self.id)
  end

  # 💡 権限管理：グループ運営の責任所在を明確化
  # 自分が作成した（責任を持つ）グループ
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :destroy

  # 💡 承認フロー：管理者に「承認」されたグループのみを「参加中」として扱う厳格な権限設計
  has_many :approved_permits, -> { where(status: :approved) }, class_name: 'Permit'
  has_many :participating_groups, through: :approved_permits, source: :group
end
