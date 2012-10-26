class Munoh < ActiveRecord::Base
  attr_accessible :name, :twitter_name 

  has_many :rooms

  validates_presence_of :name
end
