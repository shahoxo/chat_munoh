class Talk < ActiveRecord::Base
  attr_accessible :log, :room_id, :user_id
  belongs_to :room
  belongs_to :user
end
