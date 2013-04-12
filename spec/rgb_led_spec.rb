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

    it "allows you to set green anywhere from 0 to 1" do
      @led.green = 1
      @led.green.must_equal 1
    end

    it "allows you to set blue anywhere from 0 to 1" do
      @led.blue = 1
      @led.blue.must_equal 1
    end

    it "does not allow you to set intensity above 1 or below 0" do
      lambda{ @led.red = 2  }.must_raise OutOfRangeException
      lambda{ @led.red = -1 }.must_raise OutOfRangeException
    end
  end

  describe "outputting pi-blaster commands" do
    before do
      @led = RGBLed.new(red_pin: 0, green_pin: 1, blue_pin: 2)
      @led.red   = 0.5
      @led.green = 0.75
      @led.blue  = 1
    end

    it "handles red" do
      @led.pi_blast_command(:red).must_equal "echo 0=0.5 > /dev/pi-blaster"
    end

    it "handles green" do
      @led.pi_blast_command(:green).must_equal "echo 1=0.75 > /dev/pi-blaster"
    end

    it "handles blue" do
      @led.pi_blast_command(:blue).must_equal "echo 2=1 > /dev/pi-blaster"
    end
  end
end
