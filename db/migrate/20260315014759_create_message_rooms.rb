class CreateMessageRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :message_rooms do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
