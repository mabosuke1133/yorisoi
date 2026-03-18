class AddIssueIdToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :issue_id, :integer
  end
end
