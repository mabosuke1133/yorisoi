class Consultation < ApplicationRecord
  belongs_to :user
  # 💡 mentor_id を Admin モデルとして扱うための設定
  belongs_to :mentor, class_name: 'Admin', optional: true
  has_many :consultation_messages, dependent: :destroy

  # ステータスの管理（0:受付中, 1:対応中, 2:完了）
  enum status: { pending: 0, processing: 1, completed: 2 }
end