class CreateGameRoomSubscriptions < ActiveRecord::Migration
  def change
    create_table :game_room_subscriptions do |t|
      t.integer :user_id, null: false, index: true, foreign_key: true
      t.integer :game_room_id, null: false, index: true, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
  end
end
