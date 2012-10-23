class AddUserIdAndRoomsIdToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :user_id, :integer
    add_column :talks, :room_id, :integer
  end
end
