class OutOfRangeException < StandardError; end

class RGBLed
  def initialize(options={})
    @options   = options
    @pins = {
      red:   fetch_option(:red_pin),
      green: fetch_option(:green_pin),
      blue:  fetch_option(:blue_pin)
    }
    @intensity = {
      red:   0,
      green: 0,
      blue:  0
    }
  end

  def red=(value)
    set_intensity(:red, value)
  end

  def red
    get_intensity(:red)
  end

  def green=(value)
    set_intensity(:green, value)
  end

  def green
    get_intensity(:green)
  end

  def blue=(value)
    set_intensity(:blue, value)
  end

  def blue
    get_intensity(:blue)
  end

  def pi_blast_command(channel)
    "echo #{get_pin(channel)}=#{get_intensity(channel)} > /dev/pi-blaster"
  end

  def pi_blast
    %w(red green blue).each do |c|
puts pi_blast_command(c)
      `#{pi_blast_command(c)}`
    end
  end

  private
  def fetch_option(channel)
    @options.fetch(channel)  { raise "Must specify `#{channel.to_s}` option." }
  end

  def set_intensity(channel, value)
    validate_channel(channel)
    validate_intensity(value)
STDOUT.puts channel
STDOUT.puts value
    @intensity[channel.to_sym] = value
  end

  def get_intensity(channel)
    validate_channel(channel)
    @intensity[channel.to_sym]
  end

  def get_pin(channel)
    validate_channel(channel)
    @pins[channel.to_sym]
  end

  def validate_channel(channel)
    return true if valid_channels.include?(channel.to_s)
    raise "Invalid attribute channel: #{channel}"
  end

  def validate_intensity(intensity)
    return true if valid_intensities.cover?(intensity)
    raise OutOfRangeException, "Invalid intensity: #{intensity}"
  end

  def valid_channels
    %w(red green blue)
  end

  def valid_intensities
    (0..1)
  end
end
