class Permit < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # 💡 statusを言葉で扱えるように定義
  # 0: pending（保留）, 1: approved（承認）, 2: rejected（拒否）
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # 同じグループに二重で申請できないようにする
  validates :user_id, uniqueness: { scope: :group_id }
end
