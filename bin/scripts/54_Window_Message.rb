#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(80, 304, 480, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = false
    self.z = 9998
    @fade_in = false
    @fade_out = false
    @contents_showing = false
    @cursor_width = 0
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    terminate_message
    $game_temp.message_window_showing = false
    if @input_number_window != nil
      @input_number_window.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Terminate Message
  #--------------------------------------------------------------------------
  def terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    self.contents.clear
    # Clear showing flag
    @contents_showing = false
    # Call message callback
    if $game_temp.message_proc != nil
      $game_temp.message_proc.call
    end
    # Clear variables related to text, choices, and number input
    $game_temp.message_text = nil
    $game_temp.message_proc = nil
    $game_temp.choice_start = 99
    $game_temp.choice_max = 0
    $game_temp.choice_cancel_type = 0
    $game_temp.choice_proc = nil
    $game_temp.num_input_start = 99
    $game_temp.num_input_variable_id = 0
    $game_temp.num_input_digits_max = 0
    # Open gold window
    if @gold_window != nil
      @gold_window.dispose
      @gold_window = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = normal_color
    x = y = 0
    @cursor_width = 0
    # Indent if choice
    if $game_temp.choice_start == 0
      x = 8
    end
    # If waiting for a message to be displayed
    if $game_temp.message_text != nil
      text = $game_temp.message_text
      # Control text processing
      begin
        last_text = text.clone
        text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until text == last_text
      text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      # Change "\\\\" to "\000" for convenience
      text.gsub!(/\\\\/) { "\000" }
      # Change "\\C" to "\001" and "\\G" to "\002"
      text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
      text.gsub!(/\\[Gg]/) { "\002" }
      # Get 1 text character in c (loop until unable to get text)
      while ((c = text.slice!(/./m)) != nil)
        # If \\
        if c == "\000"
          # Return to original text
          c = "\\"
        end
        # If \C[n]
        if c == "\001"
          # Change text color
          text.sub!(/\[([0-9]+)\]/, "")
          color = $1.to_i
          if color >= 0 and color <= 7
            self.contents.font.color = text_color(color)
          end
          # go to next text
          next
        end
        # If \G
        if c == "\002"
          # Make gold window
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = self.y >= 128 ? 32 : 384
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          # go to next text
          next
        end
        # If new line text
        if c == "\n"
          # Update cursor width if choice
          if y >= $game_temp.choice_start
            @cursor_width = [@cursor_width, x].max
          end
          # Add 1 to y
          y += 1
          x = 0
          # Indent if choice
          if y >= $game_temp.choice_start
            x = 8
          end
          # go to next text
          next
        end
        # Draw text
        self.contents.draw_text(4 + x, 32 * y, 40, 32, c)
        # Add x to drawn text width
        x += self.contents.text_size(c).width
      end
    end
    # If choice
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
      self.active = true
      self.index = 0
    end
    # If number input
    if $game_temp.num_input_variable_id > 0
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.x = self.x + 8
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
  end
  #--------------------------------------------------------------------------
  # * Set Window Position and Opacity Level
  #--------------------------------------------------------------------------
  def reset_window
    if $game_temp.in_battle
      self.y = 16
    else
      case $game_system.message_position
      when 0  # up
        self.y = 16
      when 1  # middle
        self.y = 160
      when 2  # down
        self.y = 304
      end
    end
    if $game_system.message_frame == 0
      self.opacity = 255
    else
      self.opacity = 0
    end
    self.back_opacity = 160
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If fade in
    if @fade_in
      self.contents_opacity += 24
      if @input_number_window != nil
        @input_number_window.contents_opacity += 24
      end
      if self.contents_opacity == 255
        @fade_in = false
      end
      return
    end
    # If inputting number
    if @input_number_window != nil
      @input_number_window.update
      # Confirm
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] =
          @input_number_window.number
        $game_map.need_refresh = true
        # Dispose of number input window
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
      end
      return
    end
    # If message is being displayed
    if @contents_showing
      # If choice isn't being displayed, show pause sign
      if $game_temp.choice_max == 0
        self.pause = true
      end
      # Cancel
      if Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
          $game_system.se_play($data_system.cancel_se)
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          terminate_message
        end
      end
      # Confirm
      if Input.trigger?(Input::C)
        if $game_temp.choice_max > 0
          $game_system.se_play($data_system.decision_se)
          $game_temp.choice_proc.call(self.index)
        end
        terminate_message
      end
      return
    end
    # If display wait message or choice exists when not fading out
    if @fade_out == false and $game_temp.message_text != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      reset_window
      refresh
      Graphics.frame_reset
      self.visible = true
      self.contents_opacity = 0
      if @input_number_window != nil
        @input_number_window.contents_opacity = 0
      end
      @fade_in = true
      return
    end
    # If message which should be displayed is not shown, but window is visible
    if self.visible
      @fade_out = true
      self.opacity -= 48
      if self.opacity == 0
        self.visible = false
        @fade_out = false
        $game_temp.message_window_showing = false
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index >= 0
      n = $game_temp.choice_start + @index
      self.cursor_rect.set(8, n * 32, @cursor_width, 32)
    else
      self.cursor_rect.empty
    end
  end
end
