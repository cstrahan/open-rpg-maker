class Tone
  attr_reader :red
  attr_reader :green
  attr_reader :blue
  attr_reader :gray
  
  def red=(num)
    @red = num < -255 ? -255 : num > 255 ? 255 : num
  end

  def green=(num)
    @green =  num < -255 ? -255 : num > 255 ? 255 : num
  end
  
  def blue=(num)
    @blue =  num < -255 ? -255 : num > 255 ? 255 : num
  end
  
  def gray=(num)
    @gray =  num < 0 ? 0 : num > 255 ? 255 : num
  end
  
  def initialize(red, green, blue, gray=0)
    set red, green, blue, gray
  end
  
  def set(red, green, blue, gray=0)
    self.red = red
    self.green = green
    self.blue = blue
    self.gray = gray
  end
end