class AddPriorityToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :priority, :integer
  end
end
