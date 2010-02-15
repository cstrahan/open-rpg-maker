class Tone
  attr_reader :red, :green, :blue, :gray
  
  def red=(num)
    @red = constrain num, -255..255
  end

  def green=(num)
    @green = constrain num, -255..255
  end
  
  def blue=(num)
    @blue = constrain num, -255..255
  end
  
  def gray=(num)
    @gray = constrain num, 0..255
  end
  
  def initialize(red, green, blue, gray=0)
    set red, green, blue, gray
  end
  
  def set(red, green, blue, gray=0)
    self.red   = red
    self.green = green
    self.blue  = blue
    self.gray  = gray
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