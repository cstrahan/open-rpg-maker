#==============================================================================
# ** Window_NameInput
#------------------------------------------------------------------------------
#  This window is used to select text characters on the input name screen.
#==============================================================================

class Window_NameInput < Window_Base
  CHARACTER_TABLE =
  [
    "A","B","C","D","E",
    "F","G","H","I","J",
    "K","L","M","N","O",
    "P","Q","R","S","T",
    "U","V","W","X","Y",
    "Z"," "," "," "," ",
    "+","-","*","/","!",
    "1","2","3","4","5",
    "" ,"" ,"" ,"" ,"" ,
    "a","b","c","d","e",
    "f","g","h","i","j",
    "k","l","m","n","o",
    "p","q","r","s","t",
    "u","v","w","x","y",
    "z"," "," "," "," ",
    "#","$","%","&","@",
    "6","7","8","9","0",
    "" ,"" ,"" ,"" ,"" ,
  ]
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 128, 640, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @index = 0
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Text Character Acquisition
  #--------------------------------------------------------------------------
  def character
    return CHARACTER_TABLE[@index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...90
      x = 140 + i / 5 / 9 * 180 + i % 5 * 32
      y = i / 5 % 9 * 32
      self.contents.draw_text(x, y, 32, 32, CHARACTER_TABLE[i], 1)
    end
    self.contents.draw_text(428, 9 * 32, 48, 32, "OK", 1)
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # If cursor is positioned on [OK]
    if @index >= 90
      self.cursor_rect.set(428, 9 * 32, 48, 32)
    # If cursor is positioned on anything other than [OK]
    else
      x = 140 + @index / 5 / 9 * 180 + @index % 5 * 32
      y = @index / 5 % 9 * 32
      self.cursor_rect.set(x, y, 32, 32)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If cursor is positioned on [OK]
    if @index >= 90
      # Cursor down
      if Input.trigger?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        @index -= 90
      end
      # Cursor up
      if Input.repeat?(Input::UP)
        $game_system.se_play($data_system.cursor_se)
        @index -= 90 - 40
      end
    # If cursor is positioned on anything other than [OK]
    else
      # If right directional button is pushed
      if Input.repeat?(Input::RIGHT)
        # If directional button pressed down is not a repeat, or
        # cursor is not positioned on the right edge
        if Input.trigger?(Input::RIGHT) or
           @index / 45 < 3 or @index % 5 < 4
          # Move cursor to right
          $game_system.se_play($data_system.cursor_se)
          if @index % 5 < 4
            @index += 1
          else
            @index += 45 - 4
          end
          if @index >= 90
            @index -= 90
          end
        end
      end
      # If left directional button is pushed
      if Input.repeat?(Input::LEFT)
        # If directional button pressed down is not a repeat, or
        # cursor is not positioned on the left edge
        if Input.trigger?(Input::LEFT) or
           @index / 45 > 0 or @index % 5 > 0
          # Move cursor to left
          $game_system.se_play($data_system.cursor_se)
          if @index % 5 > 0
            @index -= 1
          else
            @index -= 45 - 4
          end
          if @index < 0
            @index += 90
          end
        end
      end
      # If down directional button is pushed
      if Input.repeat?(Input::DOWN)
        # Move cursor down
        $game_system.se_play($data_system.cursor_se)
        if @index % 45 < 40
          @index += 5
        else
          @index += 90 - 40
        end
      end
      # If up directional button is pushed
      if Input.repeat?(Input::UP)
        # If directional button pressed down is not a repeat, or
        # cursor is not positioned on the upper edge
        if Input.trigger?(Input::UP) or @index % 45 >= 5
          # Move cursor up
          $game_system.se_play($data_system.cursor_se)
          if @index % 45 >= 5
            @index -= 5
          else
            @index += 90
          end
        end
      end
      # If L or R button was pressed
      if Input.repeat?(Input::L) or Input.repeat?(Input::R)
        # Move capital / small
        $game_system.se_play($data_system.cursor_se)
        if @index < 45
          @index += 45
        else
          @index -= 45
        end
      end
    end
    update_cursor_rect
  end
end
