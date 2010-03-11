# The RGBA color class. Each component is handled with a floating point value.
class Color
  attr_reader :red, :green ,:blue ,:alpha
  
  # The red value (0-255). Values out of range are automatically corrected.
  def red=(num)
    @red = constrain num, 0..255
  end
  
  # The green value (0-255). Values out of range are automatically corrected.
  def green=(num)
    @green = constrain num, 0..255
  end
  
  # The blue value (0-255). Values out of range are automatically corrected.
  def blue=(num)
    @blue = constrain num, 0..255
  end
  
  # The alpha value (0-255). Values out of range are automatically corrected.
  def alpha=(num)
    @alpha = constrain num, 0..255
  end
  
  # Creates a Color object. If alpha is omitted, it is assumed at 255.
  def initialize(red, green, blue, alpha=255)
    set red, green, blue, alpha
  end
  
  # Sets all components at once.
  def set(red, green, blue, alpha=255)
    self.red   = red
    self.green = green
    self.blue  = blue
    self.alpha = alpha
  end
  
private

  def constrain(val, range)
    if val >= range.min && val <= range.max
      val
    elsif val < range.min
      range.min
    elsif val > range.max
      range.max 
    end
  end

end
