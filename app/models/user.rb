class User < ActiveRecord::Base
  validates_presence_of :provider
  validates_presence_of :uid
  validates_presence_of :name

  attr_accessible :name, :provider, :uid
  has_many :rooms
  has_many :talks

  def self.create_with_omniauth(auth)
    create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end
