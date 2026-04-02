class CreateConsultations < ActiveRecord::Migration[6.1]
  def change
    create_table :consultations do |t|
      t.references :user, null: false, foreign_key: true
      # 💡 mentor_id を admin テーブルへの参照として定義します
      t.references :mentor, foreign_key: { to_table: :admins } 
      t.string :title
      # 💡 status のデフォルトを 0 (受付中) に設定
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end