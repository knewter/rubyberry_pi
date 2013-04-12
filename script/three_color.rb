require_relative '../lib/inverse_rgb_led.rb'

led = InverseRGBLed.new(red_pin: 0, green_pin: 1, blue_pin: 4)
led.pi_blast

led.red=0
led.green=0
led.blue=1
led.pi_blast

require 'drb/drb'
require 'pi_piper'

# The URI for the server to connect to
URI="druby://192.168.1.76:8787"

# The object that handles requests on the server
FRONT_OBJECT=led

$SAFE = 1   # disable eval() and friends

DRb.start_service(URI, FRONT_OBJECT)
# Wait for the drb server thread to finish before exiting.
DRb.thread.join
