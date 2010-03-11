#==============================================================================
# ** Arrow_Enemy
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose enemies. This class inherits from the 
#  Arrow_Base class.
#==============================================================================

class Arrow_Enemy < Arrow_Base
  #--------------------------------------------------------------------------
  # * Get Enemy Indicated by Cursor
  #--------------------------------------------------------------------------
  def enemy
    return $game_troop.enemies[@index]
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Skip if indicating a nonexistant enemy
    $game_troop.enemies.size.times do
      break if self.enemy.exist?
      @index += 1
      @index %= $game_troop.enemies.size
    end
    # Cursor right
    if Input.repeat?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      $game_troop.enemies.size.times do
        @index += 1
        @index %= $game_troop.enemies.size
        break if self.enemy.exist?
      end
    end
    # Cursor left
    if Input.repeat?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      $game_troop.enemies.size.times do
        @index += $game_troop.enemies.size - 1
        @index %= $game_troop.enemies.size
        break if self.enemy.exist?
      end
    end
    # Set sprite coordinates
    if self.enemy != nil
      self.x = self.enemy.screen_x
      self.y = self.enemy.screen_y
    end
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    # Display enemy name and state in the help window
    @help_window.set_enemy(self.enemy)
  end
end
