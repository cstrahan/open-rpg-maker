class Tone
  attr_reader :red, :green, :blue, :gray
  
  # The red balance adjustment value (-255 to 255).
  # Values out of range are automatically corrected.
  def red=(num)
    @red = constrain num, -255..255
  end

  # The red balance adjustment value (-255 to 255).
  # Values out of range are automatically corrected.
  def green=(num)
    @green = constrain num, -255..255
  end
  
  # The blue balance adjustment value (-255 to 255).
  # Values out of range are automatically corrected.
  def blue=(num)
    @blue = constrain num, -255..255
  end
  
  # The grayscale filter strength (0 to 255).
  # Values out of range are automatically corrected.
  #
  # When this value is not 0, processing time is significantly longer than when using tone balance adjustment values alone.
  def gray=(num)
    @gray = constrain num, 0..255
  end
  
  def initialize(red, green, blue, gray=0)
    set red, green, blue, gray
  end
  
  # Sets all components at once.
  def set(red, green, blue, gray=0)
    self.red   = red
    self.green = green
    self.blue  = blue
    self.gray  = gray
  end
  
  def _dump(d = 0)
    [@red, @green, @blue, @gray].pack('d4')
  end
  
  def self._load(s)
    Tone.new(*s.unpack('d4'))
  end
  
private

  def constrain(val, range)
    if val < range.min
      range.min
    elsif val > range.max
      range.max
    else
      val
    end
  end
  
end