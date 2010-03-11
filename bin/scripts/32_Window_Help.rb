#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #  text  : text string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def set_text(text, align = 0)
    # If at least one part of text and alignment differ from last time
    if text != @text or align != @align
      # Redraw text
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 0, self.width - 40, 32, text, align)
      @text = text
      @align = align
      @actor = nil
    end
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #     actor : status displaying actor
  #--------------------------------------------------------------------------
  def set_actor(actor)
    if actor != @actor
      self.contents.clear
      draw_actor_name(actor, 4, 0)
      draw_actor_state(actor, 140, 0)
      draw_actor_hp(actor, 284, 0)
      draw_actor_sp(actor, 460, 0)
      @actor = actor
      @text = nil
      self.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Set Enemy
  #     enemy : name and status displaying enemy
  #--------------------------------------------------------------------------
  def set_enemy(enemy)
    text = enemy.name
    state_text = make_battler_state_text(enemy, 112, false)
    if state_text != ""
      text += "  " + state_text
    end
    set_text(text, 1)
  end
end
