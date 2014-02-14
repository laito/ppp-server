class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :user_id
      t.string :lat
      t.string :long
      t.string :key

      t.timestamps
    end
  end
end
