class Talk < ActiveRecord::Base
  attr_accessible :log, :room_id, :user_id
  belongs_to :room
  belongs_to :user
  validates_presence_of :room_id
  validates_presence_of :user_id

  def owner?(current_user)
    user.to_param == current_user.to_param
  end
end
