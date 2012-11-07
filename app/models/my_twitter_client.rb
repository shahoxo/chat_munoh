class MyTwitterClient
  def initialize(twitter_name)
    @twitter_name = twitter_name
    @twitter = Twitter.configure do |config|
      config.consumer_key = ENV["TWITTER_KEY"]
      config.consumer_secret = ENV["TWITTER_SECRET"]
      config.oauth_token = ENV["OAUTH_TOKEN"]
      config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
    end
  end

  def user_timeline
    timeline = Array.new
    @twitter.user_timeline(@twitter_name).each do|tweet|
      keyword = find_source_tweet(tweet.in_reply_to_status_id)
      reply = format_reply(find_source_owner(tweet.in_reply_to_user_id), tweet.text)
      timeline << {"keyword" => keyword, "reply" => reply}
    end
    timeline
  end

  def status(tweet_id)
    @twitter.status(tweet_id)
  end

  def user(user_id)
    @twitter.user(user_id)
  end

  def find_source_tweet(tweet_id)
    return unless tweet_id
    keyword = @twitter.status(tweet_id).text
    remove_noise(keyword)
  rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
    nil
  end

  def find_source_owner(user_id)
    @twitter.user(user_id).name
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