class AddGroupIdToIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :group_id, :integer
  end
end
