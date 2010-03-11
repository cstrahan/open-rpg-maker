#==============================================================================
# ** Arrow_Actor
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose an actor. This class inherits from the
#  Arrow_Base class.
#==============================================================================

class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  # * Get Actor Indicated by Cursor
  #--------------------------------------------------------------------------
  def actor
    return $game_party.actors[@index]
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Cursor right
    if Input.repeat?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      @index += 1
      @index %= $game_party.actors.size
    end
    # Cursor left
    if Input.repeat?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      @index += $game_party.actors.size - 1
      @index %= $game_party.actors.size
    end
    # Set sprite coordinates
    if self.actor != nil
      self.x = self.actor.screen_x
      self.y = self.actor.screen_y
    end
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    # Display actor status in help window
    @help_window.set_actor(self.actor)
  end
end
