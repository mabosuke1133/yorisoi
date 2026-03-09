class Group < ApplicationRecord
  # 💡 グループ作成者（Owner）への紐付け
  belongs_to :owner, class_name: 'User'
  
  # バリデーション（空欄禁止）
  validates :name, presence: true
  validates :introduction, presence: true

  has_many :permits, dependent: :destroy
  # 💡 グループに申請している「ユーザー」を直接取ってこれるようにする
  has_many :users, through: :permits
end