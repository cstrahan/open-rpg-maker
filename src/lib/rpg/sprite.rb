require 'bitmap'

module RPG
  class Sprite < ::Sprite
    @@_animations = []
    @@_reference_count = {}
    def initialize(viewport = nil)
      super(viewport)
      @_whiten_duration = 0
      @_appear_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
      @_damage_duration = 0
      @_animation_duration = 0
      @_blink = false
    end
    def dispose
      dispose_damage
      dispose_animation
      dispose_loop_animation
      super
    end
    def whiten
      self.blend_type = 0
      self.color.set(255, 255, 255, 128)
      self.opacity = 255
      @_whiten_duration = 16
      @_appear_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
    end
    def appear
      self.blend_type = 0
      self.color.set(0, 0, 0, 0)
      self.opacity = 0
      @_appear_duration = 16
      @_whiten_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
    end
    def escape
      self.blend_type = 0
      self.color.set(0, 0, 0, 0)
      self.opacity = 255
      @_escape_duration = 32
      @_whiten_duration = 0
      @_appear_duration = 0
      @_collapse_duration = 0
    end
    def collapse
      self.blend_type = 1
      self.color.set(255, 64, 64, 255)
      self.opacity = 255
      @_collapse_duration = 48
      @_whiten_duration = 0
      @_appear_duration = 0
      @_escape_duration = 0
    end
    def damage(value, critical)
      dispose_damage
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
      else
        damage_string = value.to_s
      end
      bitmap = Bitmap.new(160, 48)
      bitmap.font.name = "Arial Black"
      bitmap.font.size = 32
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(-1, 12+1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12+1, 160, 36, damage_string, 1)
      if value.is_a?(Numeric) and value < 0
        bitmap.font.color.set(176, 255, 144)
      else
        bitmap.font.color.set(255, 255, 255)
      end
      bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
      if critical
        bitmap.font.size = 20
        bitmap.font.color.set(0, 0, 0)
        bitmap.draw_text(-1, -1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(+1, -1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(-1, +1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(+1, +1, 160, 20, "CRITICAL", 1)
        bitmap.font.color.set(255, 255, 255)
        bitmap.draw_text(0, 0, 160, 20, "CRITICAL", 1)
      end
      @_damage_sprite = ::Sprite.new(self.viewport)
      @_damage_sprite.bitmap = bitmap
      @_damage_sprite.ox = 80
      @_damage_sprite.oy = 20
      @_damage_sprite.x = self.x
      @_damage_sprite.y = self.y - self.oy / 2
      @_damage_sprite.z = 3000
      @_damage_duration = 40
    end
    def animation(animation, hit)
      dispose_animation
      @_animation = animation
      return if @_animation == nil
      @_animation_hit = hit
      @_animation_duration = @_animation.frame_max
      animation_name = @_animation.animation_name
      animation_hue = @_animation.animation_hue
      bitmap = RPG::Cache.animation(animation_name, animation_hue)
      if @@_reference_count.include?(bitmap)
        @@_reference_count[bitmap] += 1
      else
        @@_reference_count[bitmap] = 1
      end
      @_animation_sprites = []
      if @_animation.position != 3 or not @@_animations.include?(animation)
        for i in 0..15
          sprite = ::Sprite.new(self.viewport)
          sprite.bitmap = bitmap
          sprite.visible = false
          @_animation_sprites.push(sprite)
        end
        unless @@_animations.include?(animation)
          @@_animations.push(animation)
        end
      end
      update_animation
    end
    def loop_animation(animation)
      return if animation == @_loop_animation
      dispose_loop_animation
      @_loop_animation = animation
      return if @_loop_animation == nil
      @_loop_animation_index = 0
      animation_name = @_loop_animation.animation_name
      animation_hue = @_loop_animation.animation_hue
      bitmap = RPG::Cache.animation(animation_name, animation_hue)
      if @@_reference_count.include?(bitmap)
        @@_reference_count[bitmap] += 1
      else
        @@_reference_count[bitmap] = 1
      end
      @_loop_animation_sprites = []
      for i in 0..15
        sprite = ::Sprite.new(self.viewport)
        sprite.bitmap = bitmap
        sprite.visible = false
        @_loop_animation_sprites.push(sprite)
      end
      update_loop_animation
    end
    def dispose_damage
      if @_damage_sprite != nil
        @_damage_sprite.bitmap.dispose
        @_damage_sprite.dispose
        @_damage_sprite = nil
        @_damage_duration = 0
      end
    end
    def dispose_animation
      if @_animation_sprites != nil
        sprite = @_animation_sprites[0]
        if sprite != nil
          @@_reference_count[sprite.bitmap] -= 1
          if @@_reference_count[sprite.bitmap] == 0
            sprite.bitmap.dispose
          end
        end
        for sprite in @_animation_sprites
          sprite.dispose
        end
        @_animation_sprites = nil
        @_animation = nil
      end
    end
    def dispose_loop_animation
      if @_loop_animation_sprites != nil
        sprite = @_loop_animation_sprites[0]
        if sprite != nil
          @@_reference_count[sprite.bitmap] -= 1
          if @@_reference_count[sprite.bitmap] == 0
            sprite.bitmap.dispose
          end
        end
        for sprite in @_loop_animation_sprites
          sprite.dispose
        end
        @_loop_animation_sprites = nil
        @_loop_animation = nil
      end
    end
    def blink_on
      unless @_blink
        @_blink = true
        @_blink_count = 0
      end
    end
    def blink_off
      if @_blink
        @_blink = false
        self.color.set(0, 0, 0, 0)
      end
    end
    def blink?
      @_blink
    end
    def effect?
      @_whiten_duration > 0 or
      @_appear_duration > 0 or
      @_escape_duration > 0 or
      @_collapse_duration > 0 or
      @_damage_duration > 0 or
      @_animation_duration > 0
    end
    def update
      super
      if @_whiten_duration > 0
        @_whiten_duration -= 1
        self.color.alpha = 128 - (16 - @_whiten_duration) * 10
      end
      if @_appear_duration > 0
        @_appear_duration -= 1
        self.opacity = (16 - @_appear_duration) * 16
      end
      if @_escape_duration > 0
        @_escape_duration -= 1
        self.opacity = 256 - (32 - @_escape_duration) * 10
      end
      if @_collapse_duration > 0
        @_collapse_duration -= 1
        self.opacity = 256 - (48 - @_collapse_duration) * 6
      end
      if @_damage_duration > 0
        @_damage_duration -= 1
        case @_damage_duration
        when 38..39
          @_damage_sprite.y -= 4
        when 36..37
          @_damage_sprite.y -= 2
        when 34..35
          @_damage_sprite.y += 2
        when 28..33
          @_damage_sprite.y += 4
        end
        @_damage_sprite.opacity = 256 - (12 - @_damage_duration) * 32
        if @_damage_duration == 0
          dispose_damage
        end
      end
      if @_animation != nil and (Graphics.frame_count % 2 == 0)
        @_animation_duration -= 1
        update_animation
      end
      if @_loop_animation != nil and (Graphics.frame_count % 2 == 0)
        update_loop_animation
        @_loop_animation_index += 1
        @_loop_animation_index %= @_loop_animation.frame_max
      end
      if @_blink
        @_blink_count = (@_blink_count + 1) % 32
        if @_blink_count < 16
          alpha = (16 - @_blink_count) * 6
        else
          alpha = (@_blink_count - 16) * 6
        end
        self.color.set(255, 255, 255, alpha)
      end
      @@_animations.clear
    end
    def update_animation
      if @_animation_duration > 0
        frame_index = @_animation.frame_max - @_animation_duration
        cell_data = @_animation.frames[frame_index].cell_data
        position = @_animation.position
        animation_set_sprites(@_animation_sprites, cell_data, position)
        for timing in @_animation.timings
          if timing.frame == frame_index
            animation_process_timing(timing, @_animation_hit)
          end
        end
      else
        dispose_animation
      end
    end
    def update_loop_animation
      frame_index = @_loop_animation_index
      cell_data = @_loop_animation.frames[frame_index].cell_data
      position = @_loop_animation.position
      animation_set_sprites(@_loop_animation_sprites, cell_data, position)
      for timing in @_loop_animation.timings
        if timing.frame == frame_index
          animation_process_timing(timing, true)
        end
      end
    end
    def animation_set_sprites(sprites, cell_data, position)
      for i in 0..15
        sprite = sprites[i]
        pattern = cell_data[i, 0]
        if sprite == nil or pattern == nil or pattern == -1
          sprite.visible = false if sprite != nil
          next
        end
        sprite.visible = true
        sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
        if position == 3
          if self.viewport != nil
            sprite.x = self.viewport.rect.width / 2
            sprite.y = self.viewport.rect.height - 160
          else
            sprite.x = 320
            sprite.y = 240
          end
        else
          sprite.x = self.x - self.ox + self.src_rect.width / 2
          sprite.y = self.y - self.oy + self.src_rect.height / 2
          sprite.y -= self.src_rect.height / 4 if position == 0
          sprite.y += self.src_rect.height / 4 if position == 2
        end
        sprite.x += cell_data[i, 1]
        sprite.y += cell_data[i, 2]
        sprite.z = 2000
        sprite.ox = 96
        sprite.oy = 96
        sprite.zoom_x = cell_data[i, 3] / 100.0
        sprite.zoom_y = cell_data[i, 3] / 100.0
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
        sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
        sprite.blend_type = cell_data[i, 7]
      end
    end
    def animation_process_timing(timing, hit)
      if (timing.condition == 0) or
         (timing.condition == 1 and hit == true) or
         (timing.condition == 2 and hit == false)
        if timing.se.name != ""
          se = timing.se
          Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
        end
        case timing.flash_scope
        when 1
          self.flash(timing.flash_color, timing.flash_duration * 2)
        when 2
          if self.viewport != nil
            self.viewport.flash(timing.flash_color, timing.flash_duration * 2)
          end
        when 3
          self.flash(nil, timing.flash_duration * 2)
        end
      end
    end
    def x=(x)
      sx = x - self.x
      if sx != 0
        if @_animation_sprites != nil
          for i in 0..15
            @_animation_sprites[i].x += sx
          end
        end
        if @_loop_animation_sprites != nil
          for i in 0..15
            @_loop_animation_sprites[i].x += sx
          end
        end
      end
      super
    end
    def y=(y)
      sy = y - self.y
      if sy != 0
        if @_animation_sprites != nil
          for i in 0..15
            @_animation_sprites[i].y += sy
          end
        end
        if @_loop_animation_sprites != nil
          for i in 0..15
            @_loop_animation_sprites[i].y += sy
          end
        end
      end
      super
    end
  end
end