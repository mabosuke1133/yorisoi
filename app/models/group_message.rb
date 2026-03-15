class GroupMessage < ApplicationRecord
  # 💡 optional: true を付けることで、管理者の投稿（user_idがない）を許可する
  belongs_to :user, optional: true
  # 管理者との紐付けを追加
  belongs_to :admin, optional: true
  
  belongs_to :group

  validates :body, presence: true # 👈 空っぽの投稿は禁止！
end
