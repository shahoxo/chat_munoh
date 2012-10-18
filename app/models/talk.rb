class Talk < ActiveRecord::Base
  attr_accessible :log, :room_id, :user_id
  belongs_to :room
  belongs_to :user
  validates_presence_of :room_id
  validates_presence_of :user_id
end
