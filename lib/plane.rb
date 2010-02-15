class Plane
  attr_accessor :bitmap
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
  attr_reader :viewport
  attr_reader :disposed

  def initialize(viewport = nil)
    raise "not implemented"

    @viewport = viewport
  end

  def dispose
    raise "not implemented"

    @disposed = true
  end

  def disposed?
    @disposed
  end

end