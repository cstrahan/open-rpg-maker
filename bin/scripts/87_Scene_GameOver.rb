#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  This class performs game over screen processing.
#==============================================================================

class Scene_Gameover
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make game over graphic
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
    # Stop BGM and BGS
    $game_system.bgm_play(nil)
    $game_system.bgs_play(nil)
    # Play game over ME
    $game_system.me_play($data_system.gameover_me)
    # Execute transition
    Graphics.transition(120)
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of game over graphic
    @sprite.bitmap.dispose
    @sprite.dispose
    # Execute transition
    Graphics.transition(40)
    # Prepare for transition
    Graphics.freeze
    # If battle test
    if $BTEST
      $scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Switch to title screen
      $scene = Scene_Title.new
    end
  end
end
