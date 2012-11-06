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
    twitter_client = MyTwitterClient.new
    twitter_client.user_timeline(self.twitter_name).each do |tweet|
      keyword = find_source_tweet(tweet.in_reply_to_status_id)
      reply = format_reply(find_source_owner(tweet.in_reply_to_user_id), tweet.text)
      self.phrases.build(keyword: keyword, reply: reply)
    end
  end

  def find_source_tweet(tweet_id)
    return unless tweet_id
    twitter_client = MyTwitterClient.new
    keyword = twitter_client.status(tweet_id).text
    remove_noise(keyword)
  rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
    nil
  end

  def find_source_owner(user_id)
    twitter_client = MyTwitterClient.new
    twitter_client.user(user_id).name
  rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
    nil
  end

  def format_reply(user_name, reply)
    if user_name
      reply.gsub! user_name, "[user_name]"
    end
    remove_noise(reply)
  end

  def remove_noise(text)
    if text
      text.gsub! /@[\S]+[\s]*/, ""
      text.gsub! %r|http://[\S]*[\s]*|, ""
    end
    text
  end
end
