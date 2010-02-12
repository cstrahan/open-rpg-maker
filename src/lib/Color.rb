class Color
  attr_reader :red
  attr_reader :green
  attr_reader :blue
  attr_reader :alpha
  
  def red=(num)
    @red = check num
  end
  
  def green=(num)
    @green = check num
  end
  
  def blue=(num)
    @blue = check num
  end
  
  def alpha=(num)
    @alpha = check num
  end
  
  def initialize(red, green, blue, alpha=255)
    set red, green, blue, alpha
  end
  
  # Not sure if alpha should have a default here...
  def set(red, green, blue, alpha=255)
    red   = red
    green = green
    blue  = blue
    alpha = alpha
  end
  
private

  def check(num)
    num < 0 ? 0 : num > 255 ? 255 : num
  end

end