# The class governing tilemaps. Tilemaps are a specialized concept used in 2D
# game map displays, created internally from multiple sprites.
class Tilemap
  # Number of frames before between each animated Auto-Tile
  Animated_Autotiles_Frames = 16
  
  # Number of autotiles to refresh at edge of viewport
  Viewport_Padding = 2
  
  Autotiles = [
    [[27, 28, 33, 34], [ 5, 28, 33, 34], [27,  6, 33, 34], [ 5,  6, 33, 34],
     [27, 28, 33, 12], [ 5, 28, 33, 12], [27,  6, 33, 12], [ 5,  6, 33, 12]],
    [[27, 28, 11, 34], [ 5, 28, 11, 34], [27,  6, 11, 34], [ 5,  6, 11, 34],
     [27, 28, 11, 12], [ 5, 28, 11, 12], [27,  6, 11, 12], [ 5,  6, 11, 12]],
    [[25, 26, 31, 32], [25,  6, 31, 32], [25, 26, 31, 12], [25,  6, 31, 12],
     [15, 16, 21, 22], [15, 16, 21, 12], [15, 16, 11, 22], [15, 16, 11, 12]],
    [[29, 30, 35, 36], [29, 30, 11, 36], [ 5, 30, 35, 36], [ 5, 30, 11, 36],
     [39, 40, 45, 46], [ 5, 40, 45, 46], [39,  6, 45, 46], [ 5,  6, 45, 46]],
    [[25, 30, 31, 36], [15, 16, 45, 46], [13, 14, 19, 20], [13, 14, 19, 12],
     [17, 18, 23, 24], [17, 18, 11, 24], [41, 42, 47, 48], [ 5, 42, 47, 48]],
    [[37, 38, 43, 44], [37,  6, 43, 44], [13, 18, 19, 24], [13, 14, 43, 44],
     [37, 42, 43, 48], [17, 18, 47, 48], [13, 18, 43, 48], [ 1,  2,  7,  8]]
  ]
    
  # Refers to the {Bitmap} used as a tileset.
  # @return [Bitmap]
  attr_accessor :tileset

  # Refers to the {Bitmap} used as an autotile with an index number from 0 to 6.
  # @return [Bitmap]
  attr_accessor :autotiles
  
  # Refers to the map data {Table}. Defines a 3-dimensional array measuring
  # [ horizontal size * vertical size * 3 ].
  # @return [Table] the map data in the form of a 3-dimensional array measuring
  #   [ horizontal size * vertical size * 3 ].
  attr_reader   :map_data
  
  # Refers to the flash data {Table} used when showing range of possible
  # movement in simulation games, etc. Defines a 2-dimensional array measuring
  # [ horizontal size * vertical size ]. This array must be the same size as the
  # map data. Each element uses 4 bits to represent a tile's flash color in RGB;
  # for example, 0xf84 flashes in RGB(15,8,4).
  # @return [Table]
  attr_accessor :flash_data
  
  # Reference to the priority {Table}. Defines a 1-dimensional array
  # containing elements corresponding to tile IDs.
  # @return [Bitmap]
  attr_accessor :priorities
  
  # The tilemap's visibility. If TRUE, the tilemap is visible.
  attr_accessor :visible
  
  # The X-coordinate of the tilemap's starting point.
  # Change this value to scroll the tilemap.
  attr_accessor :ox
  
  # The Y-coordinate of the tilemap's starting point.
  # Change this value to scroll the tilemap.
  attr_accessor :oy
  
  attr_accessor :refresh_autotiles

  def initialize(viewport)
    # Saves Viewport
    @viewport = viewport
    # Creates Blank Instance Variables
    @layers            = []    # Refers to Array of Sprites or Planes
    @tileset           = nil   # Refers to Tileset Bitmap
    @tileset_name      = ''    # Refers to Tileset Filename
    @autotiles         = []    # Refers to Array of Autotile Bitmaps
    @autotiles_name    = []    # Refers to Array of Autotile Filenames
    @map_data          = nil   # Refers to 3D Array Of Tile Settings
    @flash_data        = nil   # Refers to 3D Array of Tile Flashdata
    @priorities        = nil   # Refers to Tileset Priorities
    @visible           = true  # Refers to Tilest Visibleness
    @ox                = 0     # Bitmap Offsets         
    @oy                = 0     # Bitmap Offsets
    @dispose           = false # Disposed Flag
    @refresh_autotiles = true  # Refresh Autotile Flag
  end

  def map_data=(map_data)
    # Save Map Data
    @map_data = map_data
    
    setup
    
    # Refresh if able
    begin ; refresh ; rescue ; end
  end

  def dispose
    # Dispose Layers (Sprites)
    @layers.each { |layer| layer.dispose }
    # Set Disposed Flag to True
    @disposed = true
  end

  def disposed?
    return @disposed
  end

  def viewport
    return @viewport
  end

  def update
    # Set Refreshed Flag to On
    needs_refresh = true
    # If Map Data, Tilesize or HueChanges
    if @map_data != @refresh_data
      # Refresh Bitmaps
      refresh
      # Turns Refresh Flag to OFF
      needs_refresh = false
    end
    # Update layer Position offsets
    for layer in @layers
      layer.ox = @ox
      layer.oy = @oy
    end
    # If Refresh Autotiles, Needs Refreshed & Autotile Reset Frame
    if @refresh_autotiles && needs_refresh &&
       Graphics.frame_count % Animated_Autotiles_Frames == 0
      # Refresh Autotiles
      refresh_autotiles
    end
  end

  def setup
    # Creates Layers
    @layers = []
    for l in 0...3
      layer = Sprite.new(@viewport)
      layer.bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
      layer.z = l * 150
      layer.zoom_x = 1.0
      layer.zoom_y = 1.0
      @layers << layer
    end
    # Update Flags
    @refresh_data = nil
    @zoom_x   = 1.0
    @zoom_y   = 1.0
    @tone     = nil
    @hue      = 0
    @tilesize = 32
  end

  def refresh
    unless priorities.nil?
      # Saves Map Data & Tilesize
      @refresh_data = @map_data
      @hue      = 0
      @tilesize = 32
      # Passes Through Layers
      for z in 0...@map_data.zsize
        # Passes Through X Coordinates
        for x in 0...@map_data.xsize
          # Passes Through Z Coordinates
          for y in 0...@map_data.ysize
            # Collects Tile ID
            id = @map_data[x, y, z]
            # Skip if 0 tile
            next if id == 0
            # Passes Through All Priorities
            for p in 0..5
              # Skip If Priority Doesn't Match
              next unless p == @priorities[id]
              # Cap Priority to Layer 3
              p = 2 if p > 2
              # Draw Tile
              id < 384 ? draw_autotile(x, y, p, id) : draw_tile(x, y, p, id)
            end
          end
        end
      end
    end
  end   

  def refresh_autotiles
    # Auto-Tile Locations
    autotile_locations = Table.new(@map_data.xsize, @map_data.ysize,
      @map_data.zsize)
    # Get X Tiles
    x1 = [@ox / @tilesize - Viewport_Padding, 0].max
    x2 = [@viewport.rect.width / @tilesize +
          Viewport_Padding, @map_data.xsize].min
    # Get Y Tiles
    y1 = [@oy / @tilesize - Viewport_Padding, 0].max
    y2 = [@viewport.rect.height / @tilesize +
          Viewport_Padding, @map_data.ysize].min
    # Passes Through Layers
    for z in 0...@map_data.zsize
      # Passes Through X Coordinates
      for x in x1...x2
        # Passes Through Y Coordinates
        for y in y1...y2
          # Collects Tile ID
          id = @map_data[x, y, z]
          # Skip if 0 tile
          next if id == 0
          # Skip If Non-Animated Tile
          next unless @autotiles[id / 48 - 1].width / 96 > 1 if id < 384
          # Get Priority
          p = @priorities[id]
          # Cap Priority to Layer 3
          p = 2 if p > 2
          # If Autotile
          if id < 384
            # Draw Auto-Tile
            draw_autotile(x, y, p, id)
            for l in (p+1)...@map_data.zsize
              id_l = @map_data[x, y, l]
              draw_tile(x, y, p, id_l)
            end
            # Save Autotile Location
            autotile_locations[x, y, z] = 1
          # If Normal Tile
          else
            # If Autotile Drawn
            if autotile_locations[x, y, z] == 1
              # Redraw Normal Tile
              draw_tile(x, y, p, id)
              # Draw Higher Tiles
              for l in (p+1)...@map_data.zsize
                id_l = @map_data[x, y, l]
                draw_tile(x, y, p, id_l)
              end
            end
          end
        end
      end
    end
  end
  
  def self.autotile_tile(autotile, tile_id, hue = 0, frame_id = nil)
    # Configures Frame ID if not specified
    if frame_id.nil?
      # Animated Tiles
      frames = autotile.width / 96
      # Configures Animation Offset
      fc = Graphics.frame_count / Animated_Autotiles_Frames
      frame_id = (fc) % frames * 96
    end

    # Reconfigure Tile ID
    tile_id %= 48
    # Creates Bitmap
    bitmap = Bitmap.new(32, 32)
    # Collects Auto-Tile Tile Layout
    tiles = Autotiles[tile_id / 8][tile_id % 8]
    # Draws Auto-Tile Rects
    for i in 0...4
      tile_position = tiles[i] - 1
      src_rect = Rect.new(tile_position % 6 * 16 + frame_id,
        tile_position / 6 * 16, 16, 16)
      bitmap.blt(i % 2 * 16, i / 2 * 16, autotile, src_rect)
    end    
    # Set hue
    bitmap.hue_change(hue)
    # Return Auto-Tile
    bitmap
  end
  
  def draw_tile(x, y, z, id)
    rect = Rect.new((id - 384) % 8 * 32, (id - 384) / 8 * 32, 32, 32)
    x *= @tilesize
    y *= @tilesize
    if @tile_width == 32 && @tile_height == 32
      @layers[z].bitmap.blt(x, y, @tileset, rect)
    else
      dest_rect = Rect.new(x, y, @tilesize, @tilesize)
      @layers[z].bitmap.stretch_blt(dest_rect, @tileset, rect)
    end
  end
  
  def draw_autotile(x, y, z, tile_id)
    # Gets Autotile Filename
    autotile_num = tile_id / 48 - 1
    # Reconfigure Tile ID
    tile_id %= 48
    # Gets Generated Autotile Bitmap Section
    bitmap = Tilemap.autotile_tile(autotiles[autotile_num], tile_id, @hue)
    
    # Calculates Tile Coordinates
    x *= @tilesize
    y *= @tilesize
    @layers[z].bitmap.blt(x, y, bitmap, Rect.new(0, 0, 32, 32))
  end

  def bitmap
    # Creates New Blank Bitmap
    bitmap = Bitmap.new(@layers[0].bitmap.width, @layers[0].bitmap.height)
    # Passes Through All Layers
    for layer in @layers
      bitmap.blt(0, 0, layer.bitmap,
        Rect.new(0, 0, bitmap.width, bitmap.height))
    end
    # Return Bitmap
    return bitmap
  end
end