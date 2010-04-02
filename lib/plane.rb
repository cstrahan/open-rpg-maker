# The Plane class. Planes are special sprites that tile bitmap patterns across
# the entire screen, and are used to display panoramas and fog.
class Plane
  # Refers to the {Bitmap} used in the plane.
  attr_accessor :bitmap
  
  # Whether the plane can be seen. If TRUE, the plane is visible.
  attr_accessor :visible
  
  # The plane's Z-coordinate. The larger this value, the closer to the player the plane will be displayed. If multiple objects share the same Z-coordinate, the more recently created object will be displayed closest to the player.
  attr_accessor :z
  
  # The X-coordinate of the plane's starting point. Change this value to scroll the plane.
  attr_accessor :ox
  
  # The Y-coordinate of the plane's starting point. Change this value to scroll the plane.
  attr_accessor :oy
  
  # The plane's X-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_x
  
  # The plane's Y-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_y
  
  # The plane's opacity (0-255). Values out of range are automatically corrected.
  attr_accessor :opacity
  
  # The plane's blending mode (0: normal, 1: addition, 2: subtraction).
  attr_accessor :blend_type
  
  # The {Color} to be blended with the plane. Alpha values are used in the blending ratio.
  attr_accessor :color
  
  # The plane's color {Tone}.
  attr_accessor :tone
  
  # Retrieves the {Viewport} specified when the plane was created.
  attr_reader :viewport

  # Creates a Plane object. Specifies a Viewport (Viewport) when necessary.
  def initialize(viewport = nil)
    super()
    @viewport = viewport
    @visible = true
    @z = 0
    @ox = 0
    @oy = 0
    @zoom_x = 0
    @zoom_y = 0
    @opacity = 255
    @blend_type = 0
    @color = Color.new(0, 0, 0, 0)
    @tone = Tone.new(0, 0, 0, 0)
  end

  # Frees the plane. If the plane has already been freed, does nothing.
  def dispose
    @disposed = true
  end

  # Returns TRUE if the plane has been freed.
  def disposed?
    @disposed
  end

end
