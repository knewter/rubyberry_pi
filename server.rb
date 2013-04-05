require 'drb/drb'
require 'pi_piper'

# The URI for the server to connect to
URI="druby://192.168.1.76:8787"

class Toggler
  attr_accessor :pin, :state

  def initialize
    @pin = PiPiper::Pin.new(pin: 15, direction: :out)
    @state = false
  end

  def toggle
    state ? pin.on : pin.off
    @state = !state
    puts 'toggled'
  end
end

# The object that handles requests on the server
FRONT_OBJECT=Toggler.new

$SAFE = 1   # disable eval() and friends

DRb.start_service(URI, FRONT_OBJECT)
# Wait for the drb server thread to finish before exiting.
DRb.thread.join
