class Munoh < ActiveRecord::Base
  attr_accessible :name, :twitter_name

  validates_presence_of :name
end
