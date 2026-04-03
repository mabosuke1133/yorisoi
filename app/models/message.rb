class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  validates :content, presence: true # 空メッセージは禁止
end