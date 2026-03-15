class Issue < ApplicationRecord
  belongs_to :user

  # statusの定義（0:未対応, 1:対応中, 2:完了）
  enum status: { unstarted: 0, in_progress: 1, completed: 2 }
end