# The rectangle class.
class Rect
  # The X-coordinate of the rectangle's upper left corner.
  attr_accessor :x

  # The Y-coordinate of the rectange's upper left corner.
  attr_accessor :y

  # The rectangle's width.
  attr_accessor :width

  # The rectangle's height.
  attr_accessor :height

  def initialize(x, y, width, height)
    set x, y, width, height
  end

  # Sets all parameters at once.
  def set(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
end
