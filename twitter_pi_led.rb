require 'pi_piper'
require 'twitter/json_stream'

pin = PiPiper::Pin.new(pin: 15, direction: :out)
times = 0

EventMachine::run {
  stream = Twitter::JSONStream.connect(
    path: '/1/statuses/filter.json',
    auth: 'isotopeled:isotope11_bang',
    method: 'POST',
    content: 'track=isotope11led'
  )

  stream.each_item do |item|
    $stdout.print "item: #{item}"
    times += 1
    times.even? ? pin.on : pin.off
  end
}
