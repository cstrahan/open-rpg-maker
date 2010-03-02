# The bitmap class. Bitmaps are expressions of so-called graphics.
# Sprites ({Sprite}) and other objects must be used to display bitmaps on the screen.
class Bitmap

  # Gets the font used to draw a string with the {Bitmap#draw_text} method.
  # @return [Font] the font used to draw a string with the {Bitmap#draw_text} method.
  attr_accessor :font

  # Gets the bitmap width.
  attr_reader :width

  # Gets the bitmap height.
  attr_reader :height

  # Gets the bitmap rectangle.
  # @return [Rect] the bitmap rectangle.
  attr_reader :rect

  # A new instance of {Bitmap}. 
  # @overload initialize(filename) 
  #   Loads the graphic file specified in filename and creates a bitmap object.
  #   Also automatically searches files included in RGSS-RTP and encrypted archives. File extensions may be omitted.
  #   @return [Bitmap] a bitmap of the graphic file specified in filename.
  # @overload initialize(width, height) 
  #   Creates a bitmap object with the specified size.
  #   @return [Bitmap] a bitmap oject with the specified size.
  def intialize(*args)
    if args.size == 1
      load_file args[0]
    elsif args.size == 2
      @width = args[0]
      @height = args[1]
    end
  end

  # Frees the bitmap. If the bitmap has already been freed, does nothing.
  def dispose
    raise "not implemented"
    
    @disposed = true
  end

  # @return [true,false] _true_ if the bitmap has been freed.
  def disposed?
    @disposed
  end

  # Performs a block transfer from the src_bitmap box src_rect to the specified bitmap coordinates (x, y).
  # Opacity can be set from 0 to 255.
  #
  # @param [Number] x
  # @param [Number] y
  # @param [Bitmap] src_bitmap the bitmap to transfer. 
  # @param [Rect] src_rect the box section of the src_rect to transfer. 
  # @param [Number] opacity the opacity to use for the src_bitmap. Valid values: (0..255).
  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    raise "not implemented"
  end

  # Performs a block transfer from the src_bitmap box src_rect to the specified bitmap box dest_rect (Rect).
  # opacity can be set from 0 to 255.
  #
  # @param [Rect] dest_rect
  # @param [Bitmap] src_bitmap 
  # @param [Rect] src_rect 
  # @param [Number] opacity 
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    raise "not implemented"
  end

  # Fills the bitmap box (x, y, width, height) or rect (Rect) with color (Color).
  # @overload fill_rect(x, y, width, height, color)
  # @overload fill_rect(rect, color)
  def fill_rect(*args)
    raise "not implemented"
  end

  # Clears the entire bitmap.
  def clear
    raise "not implemented"
  end

  # Gets the {Color} at the specified pixel (x, y).
  def get_pixel(x, y)
    raise "not implemented"
  end

  # Sets the specified pixel (x, y) to the specified {Color}.
  def set_pixel(x, y, color)
    raise "not implemented"
  end

  # Changes the bitmap's hue within 360 degrees of displacement.
  # This process is time-consuming. Furthermore, due to conversion errors, repeated hue changes may result in color loss.
  def hue_change(hue)
    raise "not implemented"
  end

  # Draws a string str in the bitmap box (x, y, width, height) or rect (Rect).  
  #
  # If the text length exceeds the box's width, the text width will automatically be reduced by up to 60 percent.  
  #
  # Horizontal text is left-aligned by default; set align to 1 to center the text and to 2 to right-align it. Vertical text is always centered.  
  #
  # As this process is time-consuming, redrawing the text with every frame is not recommended.
  # 
  # @overload draw_text(x, y, width, height, str[, align])
  # @overload draw_text(rect, str[, align])
  def draw_text(*args)
    raise "not implemented"
  end
  
  # @return [Rect] the box used when drawing a string str with the draw_text method.
  #   Does not include the angled portions of italicized text.
  def text_size(str)
     raise "not implemented"
  end

  private

  def load_file(file)
     raise "not implemented"
  end
end
