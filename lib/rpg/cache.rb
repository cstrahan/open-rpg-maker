require 'bitmap'

module RPG
  # A module that loads each of RPGXP's graphic formats, creates a Bitmap object, and retains it.
  # 
  # To speed up load times and conserve memory, this module holds the created Bitmap object in an internal hash, allowing the program to return preexisting objects when the same bitmap is requested again.
  # 
  # This feature means you must take care not to use {Bitmap#dispose} to free the bitmaps specified in the origins of other sprites. If those objects have already been freed when a bitmap is requested, the objects will automatically be recreated, so it is safe to free the object if you are certain it is not referenced elsewhere. Bitmaps consume a large amount of memory, so make it a practice to free bitmaps you use only rarely.
  # 
  # If the specified file name is an empty string, the module will create and return a 32 x 32 pixel bitmap. This ensures compatibility with RPGXP's "(None)" designation.
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

    # Gets an animation graphic. Use hue to adjust its hue values.
    # @return [Bitmap] the animation graphic.
    def self.animation(filename, hue)
      self.load_bitmap("Graphics/Animations/", filename, hue)
    end

    # Gets an autotile graphic.
    # @return [Bitmap] an animation graphic.
    def self.autotile(filename)
      self.load_bitmap("Graphics/Autotiles/", filename)
    end
    
    # Gets a battle background graphic.
    # @return [Bitmap] a battle bakcground graphic.
    def self.battleback(filename)
      self.load_bitmap("Graphics/Battlebacks/", filename)
    end
    
    # Gets a battler graphic. Use hue to adjust its hue values.
    # @return [Bitmap] a battler graphic.
    def self.battler(filename, hue)
      self.load_bitmap("Graphics/Battlers/", filename, hue)
    end
    
    # Gets a character graphic. Use hue to adjust its hue values.
    # @return [Bitmap] a character graphic.
    def self.character(filename, hue)
      self.load_bitmap("Graphics/Characters/", filename, hue)
    end
    
    # Gets a fog graphic. Use hue to adjust its hue values.
    # @return [Bitmap] a fog graphic.
    def self.fog(filename, hue)
      self.load_bitmap("Graphics/Fogs/", filename, hue)
    end
    
    # Gets a "Game Over" graphic.
    # @return [Bitmap] a "Game Over" graphic.
    def self.gameover(filename)
      self.load_bitmap("Graphics/Gameovers/", filename)
    end
    
    # Gets an icon graphic.
    # @return [Bitmap] an icon graphic.
    def self.icon(filename)
      self.load_bitmap("Graphics/Icons/", filename)
    end
    
    # Gets a panorama graphic. Use hue to adjust its hue values.
    # @return [Bitmap] a panorama graphic.
    def self.panorama(filename, hue)
      self.load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    
    # Gets a picture graphic.
    # @return [Bitmap] a picture graphic.
    def self.picture(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
    
    # Gets a tileset graphic.
    # @return [Bitmap] a tileset graphic.
    def self.tileset(filename)
      self.load_bitmap("Graphics/Tilesets/", filename)
    end
    
    # Gets a title graphic.
    # @return [Bitmap] a title graphic.
    def self.title(filename)
      self.load_bitmap("Graphics/Titles/", filename)
    end
    
    # Gets a window skin graphic.
    # @return [Bitmap] a windows skin graphic.
    def self.windowskin(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
    
    # Gets only a specified tile from a tileset. Use tile_id to specify the ID of the tile to retrieve and hue to adjust its hue values.
    #
    # Used when a tile is specified in an event graphic ({RPG::Event::Page::Graphic}).
    # @return [Bitmap] the specified tile.
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
