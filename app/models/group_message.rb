class GroupMessage < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :body, presence: true # 👈 空っぽの投稿は禁止！
end
