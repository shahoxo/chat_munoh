class Munoh < ActiveRecord::Base
  attr_accessible :name, :twitter_name 

  has_many :rooms
  has_many :phrases

  validates_presence_of :name
end
