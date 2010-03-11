#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within
#  the Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :viewport1                # enemy viewport
  attr_reader   :viewport2                # actor viewport
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Make viewports
    @viewport1 = Viewport.new(0, 0, 640, 320)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport4 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 101
    @viewport3.z = 200
    @viewport4.z = 5000
    # Make battleback sprite
    @battleback_sprite = Sprite.new(@viewport1)
    # Make enemy sprites
    @enemy_sprites = []
    for enemy in $game_troop.enemies.reverse
      @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
    end
    # Make actor sprites
    @actor_sprites = []
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    # Make weather
    @weather = RPG::Weather.new(@viewport1)
    # Make picture sprites
    @picture_sprites = []
    for i in 51..100
      @picture_sprites.push(Sprite_Picture.new(@viewport3,
        $game_screen.pictures[i]))
    end
    # Make timer sprite
    @timer_sprite = Sprite_Timer.new
    # Frame update
    update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # If battleback bit map exists, dispose of it
    if @battleback_sprite.bitmap != nil
      @battleback_sprite.bitmap.dispose
    end
    # Dispose of battleback sprite
    @battleback_sprite.dispose
    # Dispose of enemy sprites and actor sprites
    for sprite in @enemy_sprites + @actor_sprites
      sprite.dispose
    end
    # Dispose of weather
    @weather.dispose
    # Dispose of picture sprites
    for sprite in @picture_sprites
      sprite.dispose
    end
    # Dispose of timer sprite
    @timer_sprite.dispose
    # Dispose of viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
    @viewport4.dispose
  end
  #--------------------------------------------------------------------------
  # * Determine if Effects are Displayed
  #--------------------------------------------------------------------------
  def effect?
    # Return true if even 1 effect is being displayed
    for sprite in @enemy_sprites + @actor_sprites
      return true if sprite.effect?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update actor sprite contents (corresponds with actor switching)
    @actor_sprites[0].battler = $game_party.actors[0]
    @actor_sprites[1].battler = $game_party.actors[1]
    @actor_sprites[2].battler = $game_party.actors[2]
    @actor_sprites[3].battler = $game_party.actors[3]
    # If battleback file name is different from current one
    if @battleback_name != $game_temp.battleback_name
      @battleback_name = $game_temp.battleback_name
      if @battleback_sprite.bitmap != nil
        @battleback_sprite.bitmap.dispose
      end
      @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
      @battleback_sprite.src_rect.set(0, 0, 640, 320)
    end
    # Update battler sprites
    for sprite in @enemy_sprites + @actor_sprites
      sprite.update
    end
    # Update weather graphic
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.update
    # Update picture sprites
    for sprite in @picture_sprites
      sprite.update
    end
    # Update timer sprite
    @timer_sprite.update
    # Set screen color tone and shake position
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    # Set screen flash color
    @viewport4.color = $game_screen.flash_color
    # Update viewports
    @viewport1.update
    @viewport2.update
    @viewport4.update
  end
end
