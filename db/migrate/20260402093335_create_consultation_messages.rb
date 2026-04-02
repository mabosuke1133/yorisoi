class CreateConsultationMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :consultation_messages do |t|
      t.references :consultation, null: false, foreign_key: true
      t.references :user, foreign_key: true # ユーザーが送る場合
      t.references :admin, foreign_key: true # 管理者が送る場合
      t.text :body, null: false

      t.timestamps
    end
  end
end
