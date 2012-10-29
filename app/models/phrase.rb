class Phrase < ActiveRecord::Base
  attr_accessible :keyword, :reply, :munoh_id

  belongs_to :munoh

  validates_presence_of :reply
end
