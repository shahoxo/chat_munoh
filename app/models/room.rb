class Room < ActiveRecord::Base
  attr_accessible :title, :user_id

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :talks
  has_many :active_users, source: :user, through: :talks, 
    conditions: proc { ['talks.created_at >= ?', 5.minutes.ago]} 

  validates_presence_of :title

  scope :in_the_room, lambda { |room| where(room_id: room.id) }

  def owner?(current_user)
    owner.to_param == current_user.to_param
  end
end
