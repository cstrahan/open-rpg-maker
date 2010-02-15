class Viewport
  attr_accessor :rect
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :color
  attr_accessor :tone

  # new(x, y, width, height)
  # new(rect)
  def initialize
    raise "not implemented"
  end

  def dispose
    @disposed = true
  end

  def disposed?
    @disposed
  end

  def flash(color, duration)
    raise "not implemented"
  end

  def update
    raise "not implemented"
  end
end