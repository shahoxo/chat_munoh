class Room < ActiveRecord::Base
  attr_accessible :title, :user_id
  belongs_to :user
  has_many :talks
  validates_presence_of :title

  def owner?(current_user)
    user.to_param == current_user.to_param
  end
end
