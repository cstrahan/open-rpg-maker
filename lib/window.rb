# The game window class. Created internally from multiple sprites.
class Window
  # Refers to the {Bitmap} used as a windowskin.
  # @returns [Bitmap]
  attr_accessor :windowskin
  
  # Refers to the {Bitmap} used for the window's contents.
  # @returns [Bitmap]
  attr_accessor :contents
  
  # The wallpaper display method. If TRUE, stretches the wallpaper graphic;
  # if FALSE, tiles it. The default value is TRUE.
  attr_accessor :stretch
  
  # The cursor box (Rect). Sets the window's upper left corner using
  # relative coordinates (-16, -16).
  # @returns [Rect]
  attr_accessor :cursor_rect
  
  # Cursor blink status. If TRUE, the cursor is blinking.
  attr_accessor :active
  
  # The window's visibility. If TRUE, the window is visible.
  attr_accessor :visible
  
  # The pause graphic's visibility. This is a symbol that appears in the message
  # window when waiting for the player to press a button.
  # If TRUE, the graphic is visible.
  attr_accessor :pause
  
  # The window's X-coordinate.
  attr_accessor :x
  
  # The window's Y-coordinate.
  attr_accessor :y
  
  # The window's width.
  attr_accessor :width
  
  # The window's height.
  attr_accessor :height
  
  # The window's Z-coordinate. The larger this value, the closer to the player
  # the window will be displayed. If multiple objects share the
  # same Z-coordinate, the more recently created object will be displayed
  # closest to the player. The Z-coordinate of the window's contents equals
  # the window background's Z-coordinate plus 2.
  attr_accessor :z
  
  # The X-coordinate of the starting point of the window's contents.
  # Change this value to scroll the window's contents.
  attr_accessor :ox
  
  # The Y-coordinate of the starting point of the window's contents.
  # Change this value to scroll the window's contents.
  attr_accessor :oy
  
  # The window's opacity (0-255).
  # Values out of range are automatically corrected.
  attr_accessor :opacity
  
  # The window background's opacity (0-255).
  # Values out of range are automatically corrected.
  attr_accessor :back_opacity
  
  # The opacity of the window's contents (0-255).
  # Values out of range are automatically corrected.
  attr_accessor :contents_opacity
  
  # Gets the {Viewport} specified when the window was created.
  # @returns [Viewport]
  attr_reader :viewport

  def initialize(viewport = nil)
    @viewport = viewport
    
    self.stretch = true
    self.active = true
    self.visible = true
    self.pause = false
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.cursor_rect = Rect.new(0,0,0,0)
    self.ox = 0
    self.oy = 0
    self.opacity = 255
    self.back_opacity = 255
    self.contents_opacity = 255
  end

  # Frees the window. If the window has already been freed, does nothing.
  def dispose
    warn 'need to implement Window.dispose'

    @disposed = true
  end

  # Returns TRUE if the window has been freed.
  def disposed?
    @disposed
  end

  # Refreshes the cursor blink and the pause graphic animation.
  # As a rule, this method is called once per frame.
  def update
    warn 'need to implement Window.update'
  end

end
