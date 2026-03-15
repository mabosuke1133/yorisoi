class ChangeUserIdNullInGroupMessages < ActiveRecord::Migration[6.1]
  def change
    # group_messagesテーブルの user_id カラムの「空（NULL）禁止」を解除する
    change_column_null :group_messages, :user_id, true
  end
end