class GroupMessage < ApplicationRecord
  # user_id が空（管理者投稿）でも保存できるようにする
  belongs_to :user, optional: true
  
  # 管理者との紐付けも、ユーザー投稿時は空になるので optional: true
  belongs_to :admin, optional: true
  
  belongs_to :group

  validates :body, presence: true

  # 💡 念のための安全策：どちらのIDも空なのは防ぐ（カスタムバリデーション）
  validate :must_have_sender

  private

  def must_have_sender
    if user_id.blank? && admin_id.blank?
      errors.add(:base, "送り主（ユーザーまたは管理者）が必要です")
    end
  end
end