class Bitmap
  attr_accessor :font
  attr_reader :width
  attr_reader :height
  attr_reader :rect

  # new(filename)
  # new(width, height) 
  def intialize(*args)
    if args.size == 1
      load_file args[0]
    elsif args.size == 2
      @width = args[0]
      @height = args[1]
    end
  end

  def dispose
    raise "not implemented"
    
    @disposed = true
  end

  def disposed?
    @disposed
  end

  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    raise "not implemented"
  end

  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    raise "not implemented"
  end

  # fill_rect(x, y, width, height, color)
  # fill_rect(rect, color)
  def fill_rect(*args)
    raise "not implemented"
  end

  def clear
    raise "not implemented"
  end

  def get_pixel(x, y)
    raise "not implemented"
  end

  def set_pixel(x, y, color)
    raise "not implemented"
  end

  def hue_change(hue)
    raise "not implemented"
  end

  # draw_text(x, y, width, height, str[, align])
  # draw_text(rect, str[, align])
  def draw_text(*args)
    raise "not implemented"
  end
  
  def text_size(str)
     raise "not implemented"
  end

private

  def load_file(file)
     raise "not implemented"
  end
end