require 'pi_piper'

pin = PiPiper::Pin.new(pin: 15, direction: :out)

5.times do
	pin.on
	sleep 1
	pin.off
	sleep 1
end
