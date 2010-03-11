#==============================================================================
# ** Arrow_Base
#------------------------------------------------------------------------------
#  This sprite is used as an arrow cursor for the battle screen. This class
#  is used as a superclass for the Arrow_Enemy and Arrow_Actor classes.
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :index                    # cursor position
  attr_reader   :help_window              # help window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = RPG::Cache.windowskin($game_system.windowskin_name)
    self.ox = 16
    self.oy = 64
    self.z = 2500
    @blink_count = 0
    @index = 0
    @help_window = nil
    update
  end
  #--------------------------------------------------------------------------
  # * Set Cursor Position
  #     index : new cursor position
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update
  end
  #--------------------------------------------------------------------------
  # * Set Help Window
  #     help_window : new help window
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    # Update help text (update_help is defined by the subclasses)
    if @help_window != nil
      update_help
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update blink count
    @blink_count = (@blink_count + 1) % 8
    # Set forwarding origin rectangle
    if @blink_count < 4
      self.src_rect.set(128, 96, 32, 32)
    else
      self.src_rect.set(160, 96, 32, 32)
    end
    # Update help text (update_help is defined by the subclasses)
    if @help_window != nil
      update_help
    end
  end
end
