#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make sprite set
    @spriteset = Spriteset_Map.new
    # Make message window
    @message_window = Window_Message.new
    # Transition run
    Graphics.transition
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
    # Dispose of sprite set
    @spriteset.dispose
    # Dispose of message window
    @message_window.dispose
    # If switching to title screen
    if $scene.is_a?(Scene_Title)
      # Fade out screen
      Graphics.transition
      Graphics.freeze
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Loop
    loop do
      # Update map, interpreter, and player order
      # (this update order is important for when conditions are fulfilled 
      # to run any event, and the player isn't provided the opportunity to
      # move in an instant)
      $game_map.update
      $game_system.map_interpreter.update
      $game_player.update
      # Update system (timer), screen
      $game_system.update
      $game_screen.update
      # Abort loop if player isn't place moving
      unless $game_temp.player_transferring
        break
      end
      # Run place move
      transfer_player
      # Abort loop if transition processing
      if $game_temp.transition_processing
        break
      end
    end
    # Update sprite set
    @spriteset.update
    # Update message window
    @message_window.update
    # If game over
    if $game_temp.gameover
      # Switch to game over screen
      $scene = Scene_Gameover.new
      return
    end
    # If returning to title screen
    if $game_temp.to_title
      # Change to title screen
      $scene = Scene_Title.new
      return
    end
    # If transition processing
    if $game_temp.transition_processing
      # Clear transition processing flag
      $game_temp.transition_processing = false
      # Execute transition
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    # If showing message window
    if $game_temp.message_window_showing
      return
    end
    # If encounter list isn't empty, and encounter count is 0
    if $game_player.encounter_count == 0 and $game_map.encounter_list != []
      # If event is running or encounter is not forbidden
      unless $game_system.map_interpreter.running? or
             $game_system.encounter_disabled
        # Confirm troop
        n = rand($game_map.encounter_list.size)
        troop_id = $game_map.encounter_list[n]
        # If troop is valid
        if $data_troops[troop_id] != nil
          # Set battle calling flag
          $game_temp.battle_calling = true
          $game_temp.battle_troop_id = troop_id
          $game_temp.battle_can_escape = true
          $game_temp.battle_can_lose = false
          $game_temp.battle_proc = nil
        end
      end
    end
    # If B button was pressed
    if Input.trigger?(Input::B)
      # If event is running, or menu is not forbidden
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        # Set menu calling flag or beep flag
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end
    end
    # If debug mode is ON and F9 key was pressed
    if $DEBUG and Input.press?(Input::F9)
      # Set debug calling flag
      $game_temp.debug_calling = true
    end
    # If player is not moving
    unless $game_player.moving?
      # Run calling of each screen
      if $game_temp.battle_calling
        call_battle
      elsif $game_temp.shop_calling
        call_shop
      elsif $game_temp.name_calling
        call_name
      elsif $game_temp.menu_calling
        call_menu
      elsif $game_temp.save_calling
        call_save
      elsif $game_temp.debug_calling
        call_debug
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Call
  #--------------------------------------------------------------------------
  def call_battle
    # Clear battle calling flag
    $game_temp.battle_calling = false
    # Clear menu calling flag
    $game_temp.menu_calling = false
    $game_temp.menu_beep = false
    # Make encounter count
    $game_player.make_encounter_count
    # Memorize map BGM and stop BGM
    $game_temp.map_bgm = $game_system.playing_bgm
    $game_system.bgm_stop
    # Play battle start SE
    $game_system.se_play($data_system.battle_start_se)
    # Play battle BGM
    $game_system.bgm_play($game_system.battle_bgm)
    # Straighten player position
    $game_player.straighten
    # Switch to battle screen
    $scene = Scene_Battle.new
  end
  #--------------------------------------------------------------------------
  # * Shop Call
  #--------------------------------------------------------------------------
  def call_shop
    # Clear shop call flag
    $game_temp.shop_calling = false
    # Straighten player position
    $game_player.straighten
    # Switch to shop screen
    $scene = Scene_Shop.new
  end
  #--------------------------------------------------------------------------
  # * Name Input Call
  #--------------------------------------------------------------------------
  def call_name
    # Clear name input call flag
    $game_temp.name_calling = false
    # Straighten player position
    $game_player.straighten
    # Switch to name input screen
    $scene = Scene_Name.new
  end
  #--------------------------------------------------------------------------
  # * Menu Call
  #--------------------------------------------------------------------------
  def call_menu
    # Clear menu call flag
    $game_temp.menu_calling = false
    # If menu beep flag is set
    if $game_temp.menu_beep
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Clear menu beep flag
      $game_temp.menu_beep = false
    end
    # Straighten player position
    $game_player.straighten
    # Switch to menu screen
    $scene = Scene_Menu.new
  end
  #--------------------------------------------------------------------------
  # * Save Call
  #--------------------------------------------------------------------------
  def call_save
    # Straighten player position
    $game_player.straighten
    # Switch to save screen
    $scene = Scene_Save.new
  end
  #--------------------------------------------------------------------------
  # * Debug Call
  #--------------------------------------------------------------------------
  def call_debug
    # Clear debug call flag
    $game_temp.debug_calling = false
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Straighten player position
    $game_player.straighten
    # Switch to debug screen
    $scene = Scene_Debug.new
  end
  #--------------------------------------------------------------------------
  # * Player Place Move
  #--------------------------------------------------------------------------
  def transfer_player
    # Clear player place move call flag
    $game_temp.player_transferring = false
    # If move destination is different than current map
    if $game_map.map_id != $game_temp.player_new_map_id
      # Set up a new map
      $game_map.setup($game_temp.player_new_map_id)
    end
    # Set up player position
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y)
    # Set player direction
    case $game_temp.player_new_direction
    when 2  # down
      $game_player.turn_down
    when 4  # left
      $game_player.turn_left
    when 6  # right
      $game_player.turn_right
    when 8  # up
      $game_player.turn_up
    end
    # Straighten player position
    $game_player.straighten
    # Update map (run parallel process event)
    $game_map.update
    # Remake sprite set
    @spriteset.dispose
    @spriteset = Spriteset_Map.new
    # If processing transition
    if $game_temp.transition_processing
      # Clear transition processing flag
      $game_temp.transition_processing = false
      # Execute transition
      Graphics.transition(20)
    end
    # Run automatic change for BGM and BGS set on the map
    $game_map.autoplay
    # Frame reset
    Graphics.frame_reset
    # Update input information
    Input.update
  end
end
