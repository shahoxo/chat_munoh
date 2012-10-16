class Room < ActiveRecord::Base
  attr_accessible :title, :user_id
  belongs_to :user
end
