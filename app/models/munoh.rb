class Munoh < ActiveRecord::Base
  attr_accessible :name, :twitter_name, :phrases_attributes

  has_many :rooms
  has_many :phrases

  validates_presence_of :name

  before_save :try_to_get_valid_response

  def valid_twitter_name?
    self.twitter_name && self.twitter_name_changed?
  end

  def try_to_get_valid_response
    return nil unless valid_twitter_name?
    retrieve_phrases_on_timeline
    self.phrases.each(&:save)
  rescue Twitter::Error::TooManyRequests, Twitter::Error::NotFound, Twitter::Error::Forbidden
    self.twitter_name = self.twitter_name_was
  end

  def retrieve_phrases_on_timeline
    twitter_client = MyTwitterClient.new(self.twitter_name)
    twitter_client.user_timeline.each do |tweet|
      self.phrases.build(keyword: tweet["keyword"], reply: tweet["reply"])
    end
  end
end
