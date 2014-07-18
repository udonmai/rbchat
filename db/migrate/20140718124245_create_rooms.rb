class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :roomname
      t.string :creator

      t.timestamps
    end
  end
end
