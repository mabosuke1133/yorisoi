class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
