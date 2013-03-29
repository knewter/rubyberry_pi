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
        STDOUT.puts 'in'
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
    @last_tweet_time = Date.parse('1900-01-01')
    @count = 0
    @pin = PiPiper::Pin.new(pin: 15, direction: :out)
  end

  def toggle_on_search
    SearchesTweets.new('isotopeled').search do |tweets|
      tweet = tweets[0]
      if(tweet)
        tweet_time = Date.parse(tweet["created_at"])
        STDOUT.puts tweet.inspect
        STDOUT.puts tweet_time
        if(tweet_time > last_tweet_time)
          STDOUT.puts count
          STDOUT.puts tweet.inspect
          @last_tweet_time = tweet_time
          @count += 1
          count.even? ? pin.on : pin.off
        end
      end
    end
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
