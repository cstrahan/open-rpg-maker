module Graphics
  class << self
    # In [Smooth Mode], the number of times the screen is refreshed per second.
    # The larger the value, the more CPU power is required. Normally set at 40.
    # When not in [Smooth Mode], the refresh rate is halved,
    # and graphics are drawn in every other frame.
    # 
    # Changing this property is not recommended; however, it can be set
    # anywhere from 10 to 120. Values out of range are automatically corrected.
    attr_accessor :frame_rate
    
    # The screen's refresh rate count. Set this property to 0 at game start
    # and the game play time (in seconds) can be calculated
    # by dividing this value by the frame_rate property value.
    attr_accessor :frame_count
  end

  # Refreshes the game screen and advances time by 1 frame. This method must
  # be called at set intervals.
  #
  # If this method is not called in 10 seconds or more, the program will view
  # the script as having run out of control and will force a quit.
  def self.update()
    raise "not implemented"
  end

  # Fixes the current screen in preparation for transitions.
  #
  #Screen rewrites are prohibited until the transition method is called.
  def self.freeze()
    raise "not implemented"
  end

  # Carries out a transition from the screen fixed in Graphics.freeze to the
  # current screen.
  # 
  # duration is the number of frames the transition will last.
  # When omitted, this value is set to 8.
  # 
  # filename specifies the transition graphic file name. When not specified,
  # a standard fade will be used. Also automatically searches files included in
  # RGSS-RTP and encrypted archives. File extensions may be omitted.
  # 
  # vague sets the ambiguity of the borderline between the graphic's starting 
  # and ending points. The larger the value, the greater the ambiguity.
  # When omitted, this value is set to 40.
  def self.transition(duration = 8, filename = nil, vague = 40)
    raise "not implemented"
  end

  # Resets the screen refresh timing. After a time-consuming process,
  # call this method to prevent extreme frame skips.
  def self.frame_reset()
    raise "not implemented"
  end
end