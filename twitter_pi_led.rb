require 'pi_piper'
require 'json'
require 'open-uri'

pin = PiPiper::Pin.new(pin: 15, direction: :out)

class SearchesTweets
  attr_reader :q

  def initialize(q)
    @q = q
  end

  def url
    "http://search.twitter.com/search.json?q=#{q}"
  end

  def search(&block)
    open(url) do |f|
      STDOUT.puts 'in'
      tweets = JSON.parse(f.read)
      yield tweets["results"]
    end
  end
end

class ToggleHandler
  attr_accessor :last_tweet_id, :count
  def initialize
    @last_tweet_id = nil
    @count = 0
  end

  def toggle_on_search
    SearchesTweets.new('isotopeled').search do |tweets|
      tweet = tweets[0]
      if(tweet)
        if(tweet["id_str"] != last_tweet_id)
          STDOUT.puts count
          STDOUT.puts tweet.inspect
          last_tweet_id = tweet["id_str"]
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
