require 'pi_piper'
require 'json'
require 'open-uri'
require 'date'

class SearchesTweets
  attr_reader :q

  def initialize(q)
    @q = q
  end

  def url
    "http://search.twitter.com/search.json?q=#{q}"
  end

  def search(&block)
    begin
      open(url) do |f|
        tweets = JSON.parse(f.read)
        yield tweets["results"]
      end
    rescue OpenURI::HTTPError
      STDOUT.puts "hey there was a 503.  We're cool guys.  Carry on."
    end
  end
end

class ToggleHandler
  attr_accessor :last_tweet_time, :count
  attr_reader :pin
  def initialize
    @last_tweet_time = Time.parse('1900-01-01')
    @count = 0
    @pin = PiPiper::Pin.new(pin: 15, direction: :out)
  end

  def toggle_on_search
    SearchesTweets.new('isotopeled').search do |tweets|
      tweet = tweets[0]
      tweet_time = Time.parse(tweet["created_at"])
      if(tweet)
        if(tweet_time > last_tweet_time)
          log_tweet(tweet, tweet_time)
          store_new_tweet(tweet_time)
          toggle_pin(tweet)
        end
      end
    end
  end

  def log_tweet(tweet, tweet_time)
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts "tweet_time: #{tweet_time}"
    puts tweet.inspect
  end

  def toggle_pin(tweet)
    text = tweet["text"]
    text =~ /on/ ? pin.on : pin.off
  end

  def store_new_tweet(tweet_time)
    @last_tweet_time = tweet_time
    @count += 1
  end

  def watch
    while(true) do
      toggle_on_search
      sleep 1
    end
  end
end

trap(:INT){ exit }

ToggleHandler.new.watch
