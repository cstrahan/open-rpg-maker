module RPG
  module Cache
    @cache = {}
    def self.load_bitmap(folder_name, filename, hue = 0)
      path = folder_name + filename
      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          @cache[path] = Bitmap.new(path)
        else
          @cache[path] = Bitmap.new(32, 32)
        end
      end
      if hue == 0
        @cache[path]
      else
        key = [path, hue]
        if not @cache.include?(key) or @cache[key].disposed?
          @cache[key] = @cache[path].clone
          @cache[key].hue_change(hue)
        end
        @cache[key]
      end
    end
    def self.animation(filename, hue)
      self.load_bitmap("Graphics/Animations/", filename, hue)
    end
    def self.autotile(filename)
      self.load_bitmap("Graphics/Autotiles/", filename)
    end
    def self.battleback(filename)
      self.load_bitmap("Graphics/Battlebacks/", filename)
    end
    def self.battler(filename, hue)
      self.load_bitmap("Graphics/Battlers/", filename, hue)
    end
    def self.character(filename, hue)
      self.load_bitmap("Graphics/Characters/", filename, hue)
    end
    def self.fog(filename, hue)
      self.load_bitmap("Graphics/Fogs/", filename, hue)
    end
    def self.gameover(filename)
      self.load_bitmap("Graphics/Gameovers/", filename)
    end
    def self.icon(filename)
      self.load_bitmap("Graphics/Icons/", filename)
    end
    def self.panorama(filename, hue)
      self.load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    def self.picture(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
    def self.tileset(filename)
      self.load_bitmap("Graphics/Tilesets/", filename)
    end
    def self.title(filename)
      self.load_bitmap("Graphics/Titles/", filename)
    end
    def self.windowskin(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
    def self.tile(filename, tile_id, hue)
      key = [filename, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        x = (tile_id - 384) % 8 * 32
        y = (tile_id - 384) / 8 * 32
        rect = Rect.new(x, y, 32, 32)
        @cache[key].blt(0, 0, self.tileset(filename), rect)
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end
    def self.clear
      @cache = {}
      GC.start
    end
  end
end
