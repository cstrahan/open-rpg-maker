class Color
  attr_reader :red, :green ,:blue ,:alpha
  
  def red=(num)
    @red = constrain num, 0..255
  end
  
  def green=(num)
    @green = constrain num, 0..255
  end
  
  def blue=(num)
    @blue = constrain num, 0..255
  end
  
  def alpha=(num)
    @alpha = constrain num, 0..255
  end
  
  def initialize(red, green, blue, alpha=255)
    set red, green, blue, alpha
  end
  
  # Not sure if alpha should have a default here...
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