require 'font'
require 'rtp'
require 'System.Drawing'

Bitmap = System::Drawing::Bitmap

# The bitmap class. Bitmaps are expressions of so-called graphics.
# Sprites ({Sprite}) and other objects must be used to display bitmaps on the screen.
class Bitmap

  # System::Drawing::Bitmap is sealed, so let's monkey patch this mofo
  # TODO: Condsider this - instead of aliasing ::System::Drawing::Bitmap as ::Object::Bitmap,
  #       Create a new Bitmap class, and redefine Bitmap.new.
  class << self
    define_method :new do |*args|
      if args.size == 1
        path = RTP.locate(args[0])
        raise "Path is not valid: #{args[0]}" if path.nil?
        bmp = self.clr_new(path)
        bmp.font = ::Font.new
        bmp
      elsif args.size == 2
        bmp = self.clr_new(args[0], args[1])
        bmp.font = ::Font.new
        bmp
      end
    end
  end

  # Gets the font used to draw a string with the {Bitmap#draw_text} method.
  # @return [Font] the font used to draw a string with the {Bitmap#draw_text} method.
  attr_accessor :font

  # Gets the bitmap width.
  #attr_reader :width

  # Gets the bitmap height.
  #attr_reader :height

  # Gets the bitmap rectangle.
  # @return [Rect] the bitmap rectangle.
  def rect
    Rect.new(0, 0, width, height)
  end

  # A new instance of {Bitmap}.
  # @overload initialize(filename)
  #   Loads the graphic file specified in filename and creates a bitmap object.
  #   Also automatically searches files included in RGSS-RTP and encrypted archives. File extensions may be omitted.
  #   @return [Bitmap] a bitmap of the graphic file specified in filename.
  # @overload initialize(width, height)
  #   Creates a bitmap object with the specified size.
  #   @return [Bitmap] a bitmap oject with the specified size.
  #def initialize(*args)
    # Placeholder. This is actually implemented in Bitmap#new because System::Drawing::Bitmap is sealed.
  #end

  # Frees the bitmap. If the bitmap has already been freed, does nothing.
  def dispose
    self.clr_member(:Dispose).call
    @disposed = true
  end

  # @return [Boolean] _true_ if the bitmap has been freed.
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
    src_rectangle    = rect_to_rectangle(src_rect)
    dest_rectangle   = rect_to_rectangle(src_rect)
    dest_rectangle.x = x
    dest_rectangle.y = y

    with_graphics do |g|
      g.draw_image(src_bitmap, dest_rectangle, src_rectangle, System::Drawing::GraphicsUnit.pixel)
    end
  end

  # Performs a block transfer from the src_bitmap box src_rect to the specified bitmap box dest_rect (Rect).
  # opacity can be set from 0 to 255.
  #
  # @param [Rect] dest_rect
  # @param [Bitmap] src_bitmap
  # @param [Rect] src_rect
  # @param [Number] opacity
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    src_rectangle    = rect_to_rectangle(src_rect)
    dest_rectangle   = rect_to_rectangle(dest_rect)

    with_graphics do |g|
      g.draw_image(src_bitmap, dest_rectangle, src_rectangle, System::Drawing::GraphicsUnit.pixel)
    end
  end

  # Fills the bitmap box (x, y, width, height) or rect (Rect) with color (Color).
  # @overload fill_rect(x, y, width, height, color)
  # @overload fill_rect(rect, color)
  def fill_rect(*args)
    case args.length
    when 5
      rect = Rect.new(*args[0..3])
      color = args.last
    when 2
      rect = args.first
      color = args.last
    else
      raise "invalid number of arguments"
    end

    rectangle = System::Drawing::Rectangle.new(rect.x, rect.y, rect.width, rect.height)
    brush = System::Drawing::SolidBrush.new(System::Drawing::Color.from_argb(color.alpha, color.red, color.green, color.blue))
    System::Drawing::Graphics.from_image(self).fill_rectangle(brush, rectangle)
  end

  # Clears the entire bitmap.
  def clear
    transparent = System::Drawing::Color.from_argb(0,0,0,0)
    System::Drawing::Graphics.from_image(self).clear(transparent)
  end

  # Gets the {Color} at the specified pixel (x, y).
  def get_pixel(x, y)
  end

  # Sets the specified pixel (x, y) to the specified {Color}.
  def set_pixel(x, y, color)
  end

  # Changes the bitmap's hue within 360 degrees of displacement.
  # This process is time-consuming. Furthermore, due to conversion errors, repeated hue changes may result in color loss.
  def hue_change(hue)
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
    # TODO: Squish text to fit rect
    # TODO: Respect alignment
    if (args.length == 5) || (args.length == 6)
      rect = Rect.new(*args[0..3])
      str = args[4]
      align = args[5] || 0
    elsif (args.length == 2) || (args.length == 3)
      rect = args[0]
      str = args[1]
      align = args[2] || 0
    end

    style = System::Drawing::FontStyle.regular
    style |= System::Drawing::FontStyle.bold if self.font.bold
    style |= System::Drawing::FontStyle.italic if self.font.italic

    brush = System::Drawing::SolidBrush.new(System::Drawing::Color.from_argb(self.font.color.alpha, self.font.color.red, self.font.color.green, self.font.color.blue))
    font = System::Drawing::Font.new(self.font.name, self.font.size, style, System::Drawing::GraphicsUnit.point)
    System::Drawing::Graphics.from_image(self).draw_string(str, font, brush, rect.x, rect.y)
  end

  # @return [Rect] the box used when drawing a string str with the draw_text method.
  #   Does not include the angled portions of italicized text.
  def text_size(str)
  end

  def dup
    clr_member(:Clone).call
  end

protected

  def rect_to_rectangle(rect)
    System::Drawing::Rectangle.new(rect.x, rect.y, rect.width, rect.height)
  end

  def with_graphics
    g = System::Drawing::Graphics.from_image(self)
    yield(g)
    g.dispose
  end
end
