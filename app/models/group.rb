class Group < ApplicationRecord
  # 💡 グループ作成者（Owner）への紐付け
  belongs_to :owner, class_name: 'User'
  
  # バリデーション（空欄禁止）
  validates :name, presence: true
  validates :introduction, presence: true

  has_many :permits, dependent: :destroy
  # 💡 グループに申請している「ユーザー」を直接取ってこれるようにする
  has_many :users, through: :permits
  # 💡 承認されたメンバーだけを抽出する「新しい名前」を作る
  has_many :approved_users, -> { where(permits: { status: :approved }) }, through: :permits, source: :user
  has_many :group_messages, dependent: :destroy
  has_many :issues, dependent: :destroy

  # 💡 承認済みのメンバー数を「オーナー(1人) + 承認済みpermit数」で計算するメソッド
  def approved_member_count
    1 + permits.where(status: "approved").count
  end

  # 💡 チャットが利用可能か（3人以上かつ有効か）を判定するメソッド
  def chat_available?
    is_active && approved_member_count >= 3
  end
end