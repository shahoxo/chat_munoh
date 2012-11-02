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
    client = twitter_client
    client.user_timeline(self.twitter_name).each do |tweet|
      keyword = nil
      if tweet.in_reply_to_status_id
        begin
          keyword = client.status(tweet.in_reply_to_status_id).text
        rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
          keyword = nil
        end
      end

      begin
        keyword_owner_name = client.user(tweet.in_reply_to_user_id).name
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        keyword_owner_name = nil
      end

      self.phrases.create(keyword: remove_noise(keyword), reply: format_reply(keyword_owner_name, tweet.text))
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
