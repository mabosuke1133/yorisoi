class Room < ApplicationRecord
  belongs_to :user # 作成者
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries # ルームに参加しているユーザーたち
  has_many :messages, dependent: :destroy
  
  validates :name, presence: true
end