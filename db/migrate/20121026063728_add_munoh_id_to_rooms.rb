class AddMunohIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :munoh_id, :integer
  end
end
