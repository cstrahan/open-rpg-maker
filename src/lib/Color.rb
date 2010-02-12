class Color
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :alpha
  
  def initialize(red, green, blue, alpha=255)
    set red, green, blue, alpha
  end
  
  # Not sure if alpha should have a default...
  def set(red, green, blue, alpha=255)
    @red   = red
    @green = green
    @blue  = blue
    @alpha = alpha
  end
end