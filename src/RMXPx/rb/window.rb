require 'bitmap'
require 'rect'
require 'sprite'
require 'color'
require 'viewport'

#==============================================================================
#   Window - Hidden RGSS Class
#------------------------------------------------------------------------------
#  by Selwyn
#==============================================================================

#==============================================================================
#   Bitmap
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # ? erase
  #--------------------------------------------------------------------------
  def erase(*args)
    if args.size == 1
      rect = args[0]
    elsif args.size == 4
      rect = Rect.new(*args)
    end
    
    color = Color.new(0, 0, 0, 0)
    fill_rect(rect, color)
  end
end

#==============================================================================
#   SG
#------------------------------------------------------------------------------
#  Selwyn's Graphics module
#==============================================================================

class Skin
  #--------------------------------------------------------------------------
  # ? instances settings
  #--------------------------------------------------------------------------
  attr_reader   :margin
  attr_accessor :bitmap
  #--------------------------------------------------------------------------
  # ? initialize
  #--------------------------------------------------------------------------
  def initialize
    @bitmap = nil
    @values = {}
    @values['bg'] = Rect.new(0, 0, 128, 128)
    @values['pause0'] = Rect.new(160, 64, 16, 16)
    @values['pause1'] = Rect.new(176, 64, 16, 16)
    @values['pause2'] = Rect.new(160, 80, 16, 16)
    @values['pause3'] = Rect.new(176, 80, 16, 16)
    @values['arrow_up'] = Rect.new(152, 16, 16, 8)
    @values['arrow_down'] = Rect.new(152, 40, 16, 8)
    @values['arrow_left'] = Rect.new(144, 24, 8, 16)
    @values['arrow_right'] = Rect.new(168, 24, 8, 16)
    self.margin = 16
  end
  #--------------------------------------------------------------------------
  # ? width
  #--------------------------------------------------------------------------
  def margin=(width)
    @margin = width
    set_values
  end
  #--------------------------------------------------------------------------
  # ? set_values
  #--------------------------------------------------------------------------
  def set_values
    w = @margin
    @values['ul_corner'] = Rect.new(128, 0, w, w)
    @values['ur_corner'] = Rect.new(192-w, 0, w, w)
    @values['dl_corner'] = Rect.new(128, 64-w, w, w)
    @values['dr_corner'] = Rect.new(192-w, 64-w, w, w)
    @values['up'] = Rect.new(128+w, 0, 64-2*w, w)
    @values['down'] = Rect.new(128+w, 64-w, 64-2*w, w)
    @values['left'] = Rect.new(128, w, w, 64-2*w)
    @values['right'] = Rect.new(192-w, w, w, 64-2*w)
  end
  #--------------------------------------------------------------------------
  # ? []
  #--------------------------------------------------------------------------
  def [](value)
    return @values[value]
  end
end


#==============================================================================
#   SG::Cursor_Rect
#==============================================================================

class Cursor_Rect

  def self.new(viewport)
    sprite = ::Sprite.new(viewport)

	sprite.instance_eval do
	  class << self
	    attr_reader   :height, :width, :skin, :margin
      end

	  @width = 0
      @height = 0
      @skin = nil
      @margin = 0
      @rect = {}
      @rect['cursor_up'] = Rect.new(129, 64, 30, 1)
      @rect['cursor_down'] = Rect.new(129, 95, 30, 1)
      @rect['cursor_left'] = Rect.new(128, 65, 1, 30)
      @rect['cursor_right'] = Rect.new(159, 65, 1, 30)
      @rect['upleft'] = Rect.new(128, 64, 1, 1)
      @rect['upright'] = Rect.new(159, 64, 1, 1)
      @rect['downleft'] = Rect.new(128, 95, 1, 1)
      @rect['downright'] = Rect.new(159, 95, 1, 1)
      @rect['bg'] = Rect.new(129, 65, 30, 30)  

      #--------------------------------------------------------------------------
      # ? margin=
      #--------------------------------------------------------------------------
      def margin=(margin)
        @margin = margin
        set(x, y, width, height)
      end
      #--------------------------------------------------------------------------
      # ? skin=
      #--------------------------------------------------------------------------
      def skin=(skin)
        @skin = skin
        draw_rect
      end
      #--------------------------------------------------------------------------
      # ? width=
      #--------------------------------------------------------------------------
      def width=(width)
        return if @width == width
        @width = width
        if @width == 0 and self.bitmap != nil
          self.bitmap.dispose
          self.bitmap = nil
        end
        draw_rect
      end
      #--------------------------------------------------------------------------
      # ? height=
      #--------------------------------------------------------------------------
      def height=(height)
        return if @height == height
        @height = height
        if @height == 0 and self.bitmap != nil
          self.bitmap.dispose
          self.bitmap = nil
        end
        draw_rect
      end
      #--------------------------------------------------------------------------
      # ? set
      #--------------------------------------------------------------------------
      def set(x, y, width, height)
        self.x = x + @margin
        self.y = y + @margin
        if @width != width or @height != height
          @width = width
          @height = height
          if width > 0 and height > 0
            draw_rect
          end
        end
      end
      #--------------------------------------------------------------------------
      # ? empty
      #--------------------------------------------------------------------------
      def empty
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
      end
      #--------------------------------------------------------------------------
      # ? draw_rect
      #--------------------------------------------------------------------------
      def draw_rect
        return if @skin == nil
        if @width > 0 and @height > 0
          self.bitmap = Bitmap.new(@width, @height)
          rect = Rect.new(1, 1, @width - 2, @height - 2)
          self.bitmap.stretch_blt(rect, @skin, @rect['bg'])
          self.bitmap.blt(0, 0, @skin, @rect['upleft'])
          self.bitmap.blt(@width-1, 0, @skin, @rect['upright'])
          self.bitmap.blt(0, @height-1, @skin, @rect['downright'])
          self.bitmap.blt(@width-1, @height-1, @skin, @rect['downleft'])
          rect = Rect.new(1, 0, @width - 2, 1)
          self.bitmap.stretch_blt(rect, @skin, @rect['cursor_up'])
          rect = Rect.new(0, 1, 1, @height - 2)
          self.bitmap.stretch_blt(rect, @skin, @rect['cursor_left'])
          rect = Rect.new(1, @height-1, @width - 2, 1)
          self.bitmap.stretch_blt(rect, @skin, @rect['cursor_down'])
          rect = Rect.new(@width - 1, 1, 1, @height - 2)
          self.bitmap.stretch_blt(rect, @skin, @rect['cursor_right'])
        end
      end
    end

	sprite
  end
end

#==============================================================================
#   SG::Window
#------------------------------------------------------------------------------
#  
#==============================================================================

class Window
  #--------------------------------------------------------------------------
  # ? set instances variables
  #--------------------------------------------------------------------------
  attr_reader(:x, :y, :z, :width, :height, :ox, :oy, :opacity, :back_opacity,
              :stretch, :contents_opacity, :visible, :pause)
  attr_accessor :active
  #--------------------------------------------------------------------------
  # ? initialize
  #--------------------------------------------------------------------------
  def initialize()
    @skin = Skin.new
    @viewport = Viewport.new(0, 0, 0, 0)
    @cr_vport = Viewport.new(0, 0, 0, 0)
    @width = 0
    @height = 0
    @ox = 0
    @oy = 0
    @opacity = 255
    @back_opacity = 255
    @contents_opacity = 255
    @frame   = Sprite.new()
    @bg      = Sprite.new()
    @window  = Sprite.new(@viewport)
    @pause_s = Sprite.new()
    @arrows = []
    for i in 0...4
      @arrows.push(Sprite.new(@cr_vport))
      @arrows[i].bitmap = Bitmap.new(16, 16)
      @arrows[i].visible = false
    end
    @cursor_rect = Cursor_Rect.new(@cr_vport)
    @cursor_rect.margin = @skin.margin
    @cursor_fade = true
    @pause_s.visible = false
    @pause = false
    @active = true
    @stretch = true
    @visible = true
    self.x = 0
    self.y = 0
    self.z = 100
    self.windowskin = RPG::Cache.windowskin($game_system.windowskin_name)
  end
  #--------------------------------------------------------------------------
  # ? contents=
  #--------------------------------------------------------------------------
  def contents=(bmp)
    @window.bitmap = bmp
    if bmp != nil
      if bmp.width > @viewport.rect.width
         bmp.height > @viewport.rect.height
        draw_arrows
      end
    end
  end
  #--------------------------------------------------------------------------
  # ? contents
  #--------------------------------------------------------------------------
  def contents
    return @window.bitmap
  end
  #--------------------------------------------------------------------------
  # ? dispose
  #--------------------------------------------------------------------------
  def dispose
    @bg.dispose
    @frame.dispose
    @window.dispose
    @cursor_rect.dispose
    @viewport.dispose
    @pause_s.dispose
    @cr_vport.dispose
    for arrow in @arrows
      arrow.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ? update
  #--------------------------------------------------------------------------
  def update
    @window.update
    @cursor_rect.update
    @viewport.update
    @cr_vport.update
    @pause_s.src_rect = @skin["pause#{(Graphics.frame_count / 8) % 4}"]
    @pause_s.update
    update_visible
    update_arrows
    if @cursor_fade
      @cursor_rect.opacity -= 10
      @cursor_fade = false if @cursor_rect.opacity <= 100
    else
      @cursor_rect.opacity += 10
      @cursor_fade = true if @cursor_rect.opacity >= 255
    end
  end
  #--------------------------------------------------------------------------
  # ? update_visible
  #--------------------------------------------------------------------------
  def update_visible
    @frame.visible = @visible
    @bg.visible = @visible
    @window.visible = @visible
    @cursor_rect.visible = @visible
    if @pause
      @pause_s.visible = @visible
    else
      @pause_s.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ? pause=
  #--------------------------------------------------------------------------
  def pause=(pause)
    @pause = pause
    update_visible
  end
  #--------------------------------------------------------------------------
  # ? update_arrows
  #--------------------------------------------------------------------------
  def update_arrows
    if @window.bitmap == nil or @visible == false
      for arrow in @arrows
        arrow.visible = false
      end
    else
      @arrows[0].visible = @oy > 0
      @arrows[1].visible = @ox > 0
      @arrows[2].visible = (@window.bitmap.width - @ox) > @viewport.rect.width
      @arrows[3].visible = (@window.bitmap.height - @oy) > @viewport.rect.height
    end
  end
  #--------------------------------------------------------------------------
  # ? visible=
  #--------------------------------------------------------------------------
  def visible=(visible)
    @visible = visible
    update_visible
    update_arrows
  end
  #--------------------------------------------------------------------------
  # ? x=
  #--------------------------------------------------------------------------
  def x=(x)
    @x = x
    @bg.x = x + 2
    @frame.x = x
    @viewport.rect.x = x + @skin.margin
    @cr_vport.rect.x = x
    @pause_s.x = x + (@width / 2) - 8
    set_arrows
  end
  #--------------------------------------------------------------------------
  # ? y=
  #--------------------------------------------------------------------------
  def y=(y)
    @y = y
    @bg.y = y + 2
    @frame.y = y
    @viewport.rect.y = y + @skin.margin
    @cr_vport.rect.y = y
    @pause_s.y = y + @height - @skin.margin
    set_arrows
  end
  #--------------------------------------------------------------------------
  # ? z=
  #--------------------------------------------------------------------------
  def z=(z)
    @z = z
    @bg.z = z
    @frame.z = z + 1
    @cr_vport.z = z + 2
    @viewport.z = z + 3
    @pause_s.z = z + 4
  end
  #--------------------------------------------------------------------------
  # ? ox=
  #--------------------------------------------------------------------------
  def ox=(ox)
    return if @ox == ox
    @ox = ox
    @viewport.ox = ox
    update_arrows
  end
  #--------------------------------------------------------------------------
  # ? oy=
  #--------------------------------------------------------------------------
  def oy=(oy)
    return if @oy == oy
    @oy = oy
    @viewport.oy = oy
    update_arrows
  end
  #--------------------------------------------------------------------------
  # ? width=
  #--------------------------------------------------------------------------
  def width=(width)
    @width = width
    @viewport.rect.width = width - @skin.margin * 2
    @cr_vport.rect.width = width
    if @width > 0 and @height > 0
      @frame.bitmap = Bitmap.new(@width, @height)
      @bg.bitmap = Bitmap.new(@width - 4, @height - 4)
      draw_window
    end
    self.x = @x
    self.y = @y
  end
  #--------------------------------------------------------------------------
  # ? height=
  #--------------------------------------------------------------------------
  def height=(height)
    @height = height
    @viewport.rect.height = height - @skin.margin * 2
    @cr_vport.rect.height = height
    if @height > 0 and @width > 0
      @frame.bitmap = Bitmap.new(@width, @height)
      @bg.bitmap = Bitmap.new(@width - 4, @height - 4)
      draw_window
    end
    self.x = @x
    self.y = @y
  end
  #--------------------------------------------------------------------------
  # ? opacity=
  #--------------------------------------------------------------------------
  def opacity=(opacity)
    value = [[opacity, 255].min, 0].max
    @opacity = value
    @contents_opacity = value
    @back_opacity = value
    @frame.opacity = value
    @bg.opacity = value
    @window.opacity = value
  end
  #--------------------------------------------------------------------------
  # ? back_opacity=
  #--------------------------------------------------------------------------
  def back_opacity=(opacity)
    value = [[opacity, 255].min, 0].max
    @back_opacity = value
    @bg.opacity = value
  end
  #--------------------------------------------------------------------------
  # ? contents_opacity=
  #--------------------------------------------------------------------------
  def contents_opacity=(opacity)
    value = [[opacity, 255].min, 0].max
    @contents_opacity = value
    @window.opacity = value
  end
  #--------------------------------------------------------------------------
  # ? cursor_rect
  #--------------------------------------------------------------------------
  def cursor_rect
    return @cursor_rect
  end
  #--------------------------------------------------------------------------
  # ? cursor_rect=
  #--------------------------------------------------------------------------
  def cursor_rect=(rect)
    @cursor_rect.x = rect.x
    @cursor_rect.y = rect.y
    if @cursor_rect.width != rect.width or @cursor_rect.height != rect.height
      @cursor_rect.set(@cursor_rect.x, @cursor_rect.y, rect.width, rect.height)
    end
  end
  #--------------------------------------------------------------------------
  # ? windowskin
  #--------------------------------------------------------------------------
  def windowskin
    return @skin.bitmap
  end
  #--------------------------------------------------------------------------
  # ? windowskin=
  #--------------------------------------------------------------------------
  def windowskin=(windowskin)
    return if windowskin == nil
    if @skin.bitmap != windowskin
      @pause_s.bitmap = windowskin
      @pause_s.src_rect = @skin['pause0']
      @skin.bitmap = windowskin
      @cursor_rect.skin = windowskin
      draw_window
      draw_arrows
    end
  end
  #--------------------------------------------------------------------------
  # ? margin=
  #--------------------------------------------------------------------------
  def margin=(margin)
    if @skin.margin != margin
      @skin.margin = margin
      self.x = @x
      self.y = @y
      temp = @height
      self.height = 0
      self.width = @width
      self.height = temp
      @cursor_rect.margin = margin
      set_arrows
    end
  end
  #--------------------------------------------------------------------------
  # ? stretch=
  #--------------------------------------------------------------------------
  def stretch=(bool)
    if @stretch != bool
      @stretch = bool
      draw_window
    end
  end
  #--------------------------------------------------------------------------
  # ? set_arrows
  #--------------------------------------------------------------------------
  def set_arrows
    @arrows[0].x = @width / 2 - 8
    @arrows[0].y = 8
    @arrows[1].x = 8
    @arrows[1].y = @height / 2 - 8
    @arrows[2].x = @width - 16
    @arrows[2].y = @height / 2 - 8
    @arrows[3].x = @width / 2 - 8
    @arrows[3].y = @height - 16
  end
  #--------------------------------------------------------------------------
  # ? draw_arrows
  #--------------------------------------------------------------------------
  def draw_arrows
    return if @skin.bitmap == nil
    @arrows[0].bitmap.blt(0, 0, @skin.bitmap, @skin['arrow_up'])
    @arrows[1].bitmap.blt(0, 0, @skin.bitmap, @skin['arrow_left'])
    @arrows[2].bitmap.blt(0, 0, @skin.bitmap, @skin['arrow_right'])
    @arrows[3].bitmap.blt(0, 0, @skin.bitmap, @skin['arrow_down'])
    update_arrows
  end
  #--------------------------------------------------------------------------
  # ? draw_window
  #--------------------------------------------------------------------------
  def draw_window
    return if @skin.bitmap == nil
    return if @width == 0 or @height == 0
    m = @skin.margin
    if @frame.bitmap.nil?
      @frame.bitmap = Bitmap.new(@width, @height)
      @bg.bitmap = Bitmap.new(@width - 4, @height - 4)
    end
    @frame.bitmap.clear
    @bg.bitmap.clear
    if @stretch
      dest_rect = Rect.new(0, 0, @width-4, @height-4)
      @bg.bitmap.stretch_blt(dest_rect, @skin.bitmap, @skin['bg'])
    else
      bgw = Integer((@width-4) / 128) + 1
      bgh = Integer((@height-4) / 128) + 1
      for x in 0..bgw
        for y in 0..bgh
          @bg.bitmap.blt(x * 128, y * 128, @skin.bitmap, @skin['bg'])
        end
      end
    end
    bx = Integer((@width - m*2) / @skin['up'].width) + 1
    by = Integer((@height - m*2) / @skin['left'].height) + 1
    for x in 0..bx
      w = @skin['up'].width
      @frame.bitmap.blt(x * w + m, 0, @skin.bitmap, @skin['up'])
      @frame.bitmap.blt(x * w + m, @height - m, @skin.bitmap, @skin['down'])
    end
    for y in 0..by
      h = @skin['left'].height
      @frame.bitmap.blt(0, y * h + m, @skin.bitmap, @skin['left'])
      @frame.bitmap.blt(@width - m, y * h + m, @skin.bitmap, @skin['right'])
    end
    @frame.bitmap.erase(@width - m, 0, m, m)
    @frame.bitmap.erase(0, @height - m, m, m)
    @frame.bitmap.erase(@width - m, @height - m, m, m)
    @frame.bitmap.blt(0, 0, @skin.bitmap, @skin['ul_corner'])
    @frame.bitmap.blt(@width - m, 0, @skin.bitmap, @skin['ur_corner'])
    @frame.bitmap.blt(0, @height - m, @skin.bitmap, @skin['dl_corner'])
    @frame.bitmap.blt(@width - m, @height - m, @skin.bitmap, @skin['dr_corner'])
  end
end