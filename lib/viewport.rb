# The viewport class. Used when displaying sprites in one portion of the screen,
# with no overflow into other regions.
class Viewport
  # The {Rect} defining the viewport.
  # @returns [Rect]
  attr_accessor :rect
  
  # The viewport's visibility. If TRUE, the viewport is visible.
  attr_accessor :visible
  
  # The viewport's Z-coordinate. The larger this value, the closer to the
  # player the viewport will be displayed. If multiple objects share the same
  # Z-coordinate, the more recently created object will be
  # displayed closest to the player.
  attr_accessor :z
  
  # The X-coordinate of the viewport's starting point.
  # Change this value to shake the screen, etc.
  attr_accessor :ox
  
  # The Y-coordinate of the viewport's starting point.
  # Change this value to shake the screen, etc.
  attr_accessor :oy
  
  # The {Color} to be blended with the viewport. Alpha values are used in the blending ratio.
  #
  # Handled separately from the color blended into a flash effect.
  # @returns [Color]
  attr_accessor :color
  
  # The viewport's color {Tone}.
  # @returns [Tone]
  attr_accessor :tone

  # new(x, y, width, height)
  # new(rect)
  def initialize
    raise "not implemented"
  end

  # Frees the viewport. If the viewport has already been freed, does nothing.
  def dispose
    @disposed = true
  end

  # Returns TRUE if the viewport has been freed.
  def disposed?
    @disposed
  end

  # Begins flashing the viewport. duration specifies the number of frames the flash will last.
  #
  # If color is set to nil, the viewport will disappear while flashing.
  def flash(color, duration)
    raise "not implemented"
  end

  # Refreshes the viewport flash. As a rule, this method is called once per frame.
  #
  # It is not necessary to call this method if no flash effect is needed.
  def update
    raise "not implemented"
  end
end