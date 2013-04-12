class OutOfRangeException < StandardError; end

class RGBLed
  def initialize(options={})
    @options   = options
    @red_pin   = fetch_option(:red_pin)
    @green_pin = fetch_option(:green_pin)
    @blue_pin  = fetch_option(:blue_pin)
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

  private
  def fetch_option(name)
    @options.fetch(name)  { raise "Must specify `#{name.to_s}` option." }
  end

  def set_intensity(name, value)
    validate_name(name)
    validate_intensity(value)
    @intensity[name.to_sym] = value
  end

  def get_intensity(name)
    validate_name(name)
    @intensity[name.to_sym]
  end

  def validate_name(name)
    return true if valid_names.include?(name.to_s)
    raise "Invalid attribute name: #{name}"
  end

  def validate_intensity(intensity)
    return true if valid_intensities.cover?(intensity)
    raise OutOfRangeException, "Invalid intensity: #{intensity}"
  end

  def valid_names
    %w(red green blue)
  end

  def valid_intensities
    (0..1)
  end
end
