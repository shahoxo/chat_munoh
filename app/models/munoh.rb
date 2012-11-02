class Munoh < ActiveRecord::Base
  attr_accessible :name, :twitter_name, :phrases_attributes

  has_many :rooms
  has_many :phrases

  validates_presence_of :name
  validate :valid_twitter_name?

  before_save :try_to_get_valid_response

  def valid_twitter_name?
    self.twitter_name && self.twitter_name_changed?
  end

  def try_to_get_valid_response
    begin
      self.set_phrases
    rescue Twitter::Error::TooManyRequests, Twitter::Error::NotFound, Twitter::Error::Forbidden
      self.twitter_name = self.twitter_name_was
    end
  end

  def twitter_client
    Twitter::Client.new(
        :consumer_key => ENV["TWITTER_KEY"],
        :consumer_secret => ENV["TWITTER_SECRET"],
        :oauth_token => ENV["OAUTH_TOKEN"],
        :oauth_token_secret => ENV["OAUTH_TOKEN_SECRET"]
    )
  end

  def set_phrases
    twitter_client.user_timeline(self.twitter_name).each do |tweet|
      keyword = find_source_tweet(tweet.in_reply_to_status_id)
      reply = format_reply(find_source_owner(tweet.in_reply_to_user_id), tweet.text)
      self.phrases.create(keyword: keyword, reply: reply)
    end
  end

  def find_source_tweet(tweet_id)
    keyword = nil
    if tweet_id
      begin
        keyword = twitter_client.status(tweet_id).text
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        keyword = nil
      end
    end
    remove_noise(keyword)
  end

  def find_source_owner(user_id)
    begin
      twitter_client.user(user_id).name
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      nil
    end
  end

  def format_reply(user_name, reply)
    if user_name
      reply.gsub! user_name, "[user_name]"
    end
    remove_noise(reply)
  end

  def remove_noise(text)
    if text
      text.gsub! /@[^ ]+[ ]*/, ""
      text.gsub! %r|http://[^ ]*[ ]*|, ""
    end
    text
  end
end
