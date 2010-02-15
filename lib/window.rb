class Window
  attr_accessor :windowskin
  atrr_accessor :contents
  atrr_accessor :stretch
  atrr_accessor :cursor_rect
  atrr_accessor :active
  atrr_accessor :visible
  atrr_accessor :pause
  atrr_accessor :x
  atrr_accessor :y
  atrr_accessor :width
  atrr_accessor :height
  atrr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :opacity
  attr_accessor :back_opacity
  attr_accessor :contents_opacity
  attr_reader :viewport

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

  def update
    raise "not implemented"
  end

end