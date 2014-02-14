class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :room_id
      t.integer :numlikes
      t.integer :numcomments
      t.attachment :photo

      t.timestamps
    end
  end
end
