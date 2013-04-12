require_relative 'rgb_led'
class InverseRGBLed < RGBLed
def get_intensity(channel)
1-super
end

end
