class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title, null: false
      t.references :user
      t.timestamps
    end
  end
end
