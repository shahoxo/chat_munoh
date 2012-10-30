class AddIndexIdToMunohs < ActiveRecord::Migration
  def change
    add_index :munohs, :id
  end
end
