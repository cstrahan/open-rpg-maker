# The sprite class.
# Sprites are the basic concept used to display
# characters, etc. on the game screen.
class Sprite
  # Refers to the {Bitmap} used for the sprite's starting point.
  attr_accessor :bitmap
  
  # The box (Rect) taken from a bitmap.
  attr_accessor :src_rect
  
  # The sprite's visibility. If TRUE, the sprite is visible.
  attr_accessor :visible 

  # The sprite's X-coordinate.
  attr_accessor :x

  # The sprite's Y-coordinate.
  attr_accessor :y

  # The viewport's Z-coordinate. The larger this value, the closer
  # to the player the viewport will be displayed. If multiple objects share
  # the same Z-coordinate, the more recently created object will be displayed
  # closest to the player.
  attr_accessor :z

  # The X-coordinate of the sprite's starting point.
  attr_accessor :ox

  # The Y-coordinate of the sprite's starting point.
  attr_accessor :oy

  # The sprite's X-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_x

  # The sprite's Y-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_y

  # The sprite's angle of rotation. Specifies up to 360 degrees of
  # counterclockwise rotation. However, drawing a rotated sprite is
  # time-consuming, so avoid overuse.
  attr_accessor :angle

  # Flag denoting the sprite has been flipped horizontally.
  # If TRUE, the sprite will be drawn flipped.
  attr_accessor :mirror

  # The Bush depth for that sprite. This is a pixel value denoting how much of
  # the sprite's lower portion will be displayed as semitransparent.
  # A simple way to convey a sense of a character's feet being obscured by
  # foliage and the like.
  attr_accessor :bush_depth
 
  # The sprite's opacity (0-255). Values out of range are automatically corrected.
  attr_accessor :opacity

  # The sprite's blending mode (0: normal, 1: addition, 2: subtraction).
  attr_accessor :blend_type

  # The color (Color) to be blended with the sprite.
  # Alpha values are used in the blending ratio.
  #
  # Handled separately from the color blended into a flash effect.
  # However, the color with the higher alpha value when displayed will
  # have the higher priority when blended.
  attr_accessor :color

  # The sprite's color {Tone}.
  attr_accessor :tone

  # Gets the {Viewport} specified when the tilemap was created.
  attr_reader :viewport

  def initialize(viewport = nil)
    raise "not implemented"

    @viewport = viewport
  end

  # Frees the sprite. If the sprite has already been freed, does nothing.
  def dispose
    raise "not implemented"

    @disposed = true
  end

  # Returns TRUE if the sprite has been freed.
  def disposed?
    @disposed
  end

  # Begins flashing the sprite.
  # duration specifies the number of frames the flash will last.
  #
  # If color is set to nil, the sprite will disappear while flashing.
  def flash(color, duration) 
    raise "not implemented"
  end  

  # Refreshes the sprite flash. As a rule, this method is called once per frame.
  #
  # It is not necessary to call this method if no flash effect is needed.
  def update
    raise "not implemented"
  end  
end