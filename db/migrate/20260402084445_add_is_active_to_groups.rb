class AddIsActiveToGroups < ActiveRecord::Migration[6.1]
  def change
    # default: true にすることで、既存のグループもすべて「有効」な状態で始められます
    add_column :groups, :is_active, :boolean, default: true
  end
end