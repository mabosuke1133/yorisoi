class AddAdminIdToGroupMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :group_messages, :admin_id, :integer
  end
end
