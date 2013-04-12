require 'turn/autorun'
require 'minitest/spec'
require_relative '../lib/rgb_led'

describe RGBLed do
  it "can be instantiated with three GPIO pin numbers" do
    led = RGBLed.new(red_pin: 0, green_pin: 1, blue_pin: 2)
  end

  describe "setting color intensity" do
    before do
      @led = RGBLed.new(red_pin: 0, green_pin: 1, blue_pin: 2)
    end

    it "allows you to set red anywhere from 0 to 1" do
      @led.red = 1
      @led.red.must_equal 1
    end

    it "does not allow you to set intensity above 1 or below 0" do
      lambda{ @led.red = 2  }.must_raise OutOfRangeException
      lambda{ @led.red = -1 }.must_raise OutOfRangeException
    end
  end
end
