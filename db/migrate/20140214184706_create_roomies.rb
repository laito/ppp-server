class CreateRoomies < ActiveRecord::Migration
  def change
    create_table :roomies do |t|
      t.integer :room_id
      t.integer :user_id

      t.timestamps
    end
  end
end
