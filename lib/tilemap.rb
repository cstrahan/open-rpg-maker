#==============================================================================
# ** Tilemap (hidden class)
#------------------------------------------------------------------------------
#  This class handles the map data to screen processing
#==============================================================================

#==============================================================================
# 
#   Yet another Tilemap Script (for any map size /w autotiles)
#   by Me™ / Derk-Jan Karrenbeld (me@solarsoft.nl)
#   version 1.0 released on 08 nov 08
#   version 1.2
#
#==============================================================================
class Tilemap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :tileset
  attr_reader :autotiles
  attr_reader :flash_data
  attr_reader :priorities
  attr_reader :visible
  attr_reader :ox, :oy
  attr_writer :autotiles
  
  #--------------------------------------------------------------------------
  # * Constant Configuration
  #--------------------------------------------------------------------------
  
  # Window Rect - the visible Area of the Map (default: 640 x 480)
  # Bitmap Rect - the active drawing Area of the Map (window tiles + 2 tiles)
  # BitmapWindow offset - the invisible tile count on one side
  WindowRect = Rect.new(0,0,640,480)
  BitmapRect = Rect.new(0,0,640 + 64, 480 + 64) # Recommended
  BitmapWindowOffset = (BitmapRect.height-WindowRect.height)/2/32
  
  # Length in frames of one frame showing from autotile
  AutotileLength = 10
  
  # KillOutScreenSprite - Kills priority and autotile sprites out of screen
  # EnableFlashingData - If activated, enables updating flashing data
  KillOutScreenSprite   = true
  EnableFlashingData    = false
  
  # SingleFlashingSprite - Uses one Flashing sprite, instead of many
  # SinglePrioritySprite - Uses one Priority sprite, instead of many
  # SingleAutotileSprite - Uses one Autotile sprite, instead of many
  SingleFlashingSprite  = false
  SinglePrioritySprite  = false
  SingleAutotileSprite  = false
  
  # This is the Autotile animation graphical index array. It contains numbers
  # that point to the graphic part of an animating autotile.
  Autotiles = [
    [ [27, 28, 33, 34], [ 5, 28, 33, 34], [27,  6, 33, 34], [ 5,  6, 33, 34],
      [27, 28, 33, 12], [ 5, 28, 33, 12], [27,  6, 33, 12], [ 5,  6, 33, 12] ],
    [ [27, 28, 11, 34], [ 5, 28, 11, 34], [27,  6, 11, 34], [ 5,  6, 11, 34],
      [27, 28, 11, 12], [ 5, 28, 11, 12], [27,  6, 11, 12], [ 5,  6, 11, 12] ],
    [ [25, 26, 31, 32], [25,  6, 31, 32], [25, 26, 31, 12], [25,  6, 31, 12],
      [15, 16, 21, 22], [15, 16, 21, 12], [15, 16, 11, 22], [15, 16, 11, 12] ],
    [ [29, 30, 35, 36], [29, 30, 11, 36], [ 5, 30, 35, 36], [ 5, 30, 11, 36],
      [39, 40, 45, 46], [ 5, 40, 45, 46], [39,  6, 45, 46], [ 5,  6, 45, 46] ],
    [ [25, 30, 31, 36], [15, 16, 45, 46], [13, 14, 19, 20], [13, 14, 19, 12],
      [17, 18, 23, 24], [17, 18, 11, 24], [41, 42, 47, 48], [ 5, 42, 47, 48] ],
    [ [37, 38, 43, 44], [37,  6, 43, 44], [13, 18, 19, 24], [13, 14, 43, 44],
      [37, 42, 43, 48], [17, 18, 47, 48], [13, 18, 43, 48], [ 1,  2,  7,  8] ]
  ]
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : the drawing viewport
  #     rpgmap : the rpgmap object
  #--------------------------------------------------------------------------
  def initialize(viewport = nil, rpgmap = nil)
    # Autotiles Array
    @autotiles    = Array.new(6, nil)
    @oldautotiles = Array.new(6, nil)
    # Tilemap Viewport
    @viewport   = viewport ? viewport : Viewport.new(WindowRect)
    # Showing Region Rectangle
    @region     = Rect.new(0,0,BitmapRect.width/32, BitmapRect.height/32)
    # Old Region Rect
    @oldregion  = nil
    # Set TilemapSprite
    @sprite     = Sprite.new(@viewport)
    # Set Bitmap on Sprite
    @sprite.bitmap = Bitmap.new(BitmapRect.width, BitmapRect.height)
    # Set FlashingSprite and bitmap
    if SingleFlashingSprite
      @flashsprite = Sprite.new(@viewport)
      @flashsprite.bitmap = Bitmap.new(BitmapRect.width, BitmapRect.height)
    end
    # Set Informational Arrays/Hashes
    @priority_ids     = {}  # Priority ids
    @normal_tiles     = {}  # Non-auto tile bitmaps
    @auto_tiles       = {}  # Autotile bitmaps
    @priority_sprites = []  # Priority Sprites
    @autotile_sprites = []  # Autotile Sprites
    @flashing_sprites = []  # Flashing Sprites
    # Disposal Boolean
    @disposed   = false
    # Visibility Boolean
    @visible    = true
    # Flashing Boolean
    @flashing   = true
    # Disable Drawing Boolean
    @can_draw   = true
    # Set Coords
    @ox, @oy = 0, 0
    # Create TileMap if rpgmap is provided
    create_tilemap(rpgmap) if !rpgmap.nil?
  end
  #--------------------------------------------------------------------------
  # * Get Bitmap Sprite
  #--------------------------------------------------------------------------
  def sprite_bitmap
    return @sprite.bitmap
  end
  #--------------------------------------------------------------------------
  # * Data Tileset Referer - loads if needed
  #--------------------------------------------------------------------------
  def data_tilesets
    $data_tilesets ||= load_data("Data/Tilesets.rxdata")
  end
  #--------------------------------------------------------------------------
  # * Check: Disposed?
  #--------------------------------------------------------------------------
  def disposed?
    @disposed
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Dispose all sprites (and cached bitmaps for quick memory clearing)
    for sprite in [@sprite] + @normal_tiles.values + @auto_tiles.values + @priority_sprites + @autotile_sprites + (SingleFlashingSprite ? [@flashsprite] : @flashing_sprites)
      sprite = sprite[0] if sprite.is_a?(Array)
      sprite.dispose if sprite.is_a?(Bitmap)
    end
    # Set Informational Arrays/Hashes
    @priority_ids     = {}  # Priority ids
    @normal_tiles     = {}  # Non-auto tile bitmaps
    @priority_sprites = []  # Priority Sprites
    @autotile_sprites = []  # Autotile Sprites
    @flashing_sprites = []  # Flashing Sprites
    # I am disposed
    @disposed = true
  end
  #--------------------------------------------------------------------------
  # * Checking: Drawing Allowed
  #--------------------------------------------------------------------------
  def drawing?
    @can_draw
  end
  #--------------------------------------------------------------------------
  # * Enable Drawing
  #--------------------------------------------------------------------------
  def enable_drawing
    @can_draw = true
  end
  #--------------------------------------------------------------------------
  # * Disable Drawing
  #--------------------------------------------------------------------------
  def disable_drawing
    @can_draw = true
  end
  #--------------------------------------------------------------------------
  # * Enable Flashing
  #--------------------------------------------------------------------------
  def enable_flashing
    @flashing = true
  end
  #--------------------------------------------------------------------------
  # * Disable Flashing
  #--------------------------------------------------------------------------
  def disable_flashing
    @flashing = false
  end
  #--------------------------------------------------------------------------
  # * Check: Flashing
  #--------------------------------------------------------------------------
  def flashing?
    EnableFlashingData and @flashing and @flashing_sprites.size
  end
  #--------------------------------------------------------------------------
  # * Check: Visible
  #--------------------------------------------------------------------------
  def visible?
    @visible
  end
  #--------------------------------------------------------------------------
  # * Check: Autotiles Changed
  #--------------------------------------------------------------------------
  def autotiles_changed?
    @oldautotiles != @autotiles
  end
  #--------------------------------------------------------------------------
  # * Set Visibility
  #     value: new value
  #--------------------------------------------------------------------------
  def visible=(value)
    # Set Visibility value
    @visible = value
    # Update all sprites
    for sprite in [@sprite] + @priority_sprites + @autotile_sprites + (SingleFlashingSprite ? [@flashsprite] : @flashing_sprites)
      sprite = sprite[0] if sprite.is_a?(Array)
      sprite.visible = value
    end
  end
  #--------------------------------------------------------------------------
  # * Set Tileset
  #     value : new RPG::Tileset, String or Bitmap
  #--------------------------------------------------------------------------
  def tileset=(value)
    # Return on equal data
    return if @tileset == value
    # Set TilesetName
    value = value.tileset_name if value.is_a?(RPG::Tileset)
    # Cache Tileset
    @tileset = RPG::Cache.tileset(value) if value.is_a?(String)
    # Set Tileset
    @tileset = value if value.is_a?(Bitmap)
    # Draw Tileset
    redraw_tileset if @can_draw
  end
  #--------------------------------------------------------------------------
  # * Set Priorities
  #     value : new value
  #--------------------------------------------------------------------------
  def priorities=(value)
    # Return on equal data
    return if @priorities == value
    # Set Priorities
    @priorities = value
    # Draw Tileset
    redraw_priorities if @can_draw
  end
  #--------------------------------------------------------------------------
  # * Set flash data
  #     coord[0] : x
  #     coord[1] : y
  #     value    : Color or Hex
  #--------------------------------------------------------------------------
  def flash_data=(*coord, &value)
    # Return on equal data
    return if @flash_data[coord[0],coord[1]] == value
    # Already Flashing this tile?
    flashing = !@flash_data[x,y].nil?
    # Set Flash Data
    @flash_data[x,y] = value
    return if !EnableFlashingData
    # Take action and remove/change/add flash
    if value.nil?
      remove_flash(x,y)
    elsif flashing
      change_flash(x,y,value)
    else
      add_flash(x,y,value)
    end
  end
  #--------------------------------------------------------------------------
  # * Map Data referer
  #--------------------------------------------------------------------------
  def map_data
    @map_data
  end
  #--------------------------------------------------------------------------
  # * Set Map Data
  #     value : new Table value
  #--------------------------------------------------------------------------
  def map_data=(value)
    # Return on equal data
    return if @map_data == value
    # Set New Map Data
    @map_data = value
    # Flash Data Table
    @flash_data = Table.new(@map_data.xsize, @map_data.ysize)
    # Redraw Current Region
    draw_region if @can_draw and @priorities and @tileset
  end
  #--------------------------------------------------------------------------
  # * Get Map width (in tiles)
  #--------------------------------------------------------------------------
  def map_tile_width
    map_data.xsize
  end
  #--------------------------------------------------------------------------
  # * Get Map height (in tiles)
  #--------------------------------------------------------------------------
  def map_tile_height
    map_data.ysize
  end
  #--------------------------------------------------------------------------
  # * Create Tilemap
  #     rpgmap : base object
  #--------------------------------------------------------------------------
  def create_tilemap(rpgmap)
    # Return on invalid data
    return if rpgmap.is_a?(RPG::Map) == false
    # Restrict drawing
    @can_draw = false
    # Set Local Tileset Object (RPG::Tileset)
    _tileset = data_tilesets[rpgmap.tileset_id]
    # Return on invalid data
    return if _tileset.is_a?(RPG::Tileset) == false
    # Set Informational Arrays/Hashes
    @priority_ids     = {}  # Priority ids
    @normal_tiles     = {}  # Non-auto tile bitmaps
    @priority_sprites = []  # Priority Sprites
    @autotile_sprites = []  # Autotile Sprites
    @flashing_sprites = []  # Flashing Sprites
    # Set Tileset
    tileset = _tileset.tileset_name
    # Set AutoTiles
    (0..6).each { |i| autotiles[i] = _tileset.autotile_names[i] }
    # Set Priorities
    priorities = _tileset.priorities
    # Set Mapdata
    map_data = rpgmap.map_data
    # Reset drawing
    @can_draw = true
    # Reset disposed (need to reinit info variables)
    @disposed = false
    # Draw Region
    draw_region
  end
  #--------------------------------------------------------------------------
  # * Get Tile id
  #     x : x tile coord
  #     y : y tile coord
  #     z : z layer coord
  #--------------------------------------------------------------------------
  def tile_id(x, y, z)
    return map_data[x, y, z]
  end
  #--------------------------------------------------------------------------
  # * Get Priority
  #     args (1) : tile_id
  #     args (3) : x, y, z coord
  #--------------------------------------------------------------------------
  def priority(*args)
    return @priorities[args[0]] if args.size == 1
    return @priorities[tile_id(args[0], args[1], args[2])]
  end
  #--------------------------------------------------------------------------
  # * Redraw Tileset (on change)
  #--------------------------------------------------------------------------
  def redraw_tileset
    # Kill current bitmap
    sprite_bitmap.clear
    # Get rid of tile bitmaps
    @normal_tiles.clear
    # Get rid of autotile bitmaps
    @auto_tiles.clear
    # Dispose current tiles in screen
    (@autotile_sprites + @priority_sprites).each { |sprite| sprite[0].dispose if !sprite[0].disposed? }
    # Clear disposed graphics
    @autotile_sprites.clear; @priority_sprites.clear
    # Draw if allowed
    draw_region if @can_draw and @priorities and @tileset
  end
  #--------------------------------------------------------------------------
  # * Redraw Priorities (on change)
  #--------------------------------------------------------------------------
  def redraw_priorities
    # Dispose current tiles in screen
    (@autotile_sprites + @priority_sprites).each { |sprite| sprite[0].dispose if !sprite[0].disposed? }
    # Clear disposed graphics
    @priority_sprites.clear; @autotile_sprites.clear
    # Clear Priority id information
    @priority_ids.clear
    # Do a one time check for all priorities (can't do @tileset.priorities
    # because RPG::Tilemap is normally not passed trough, but if it were, you
    # can do the following - just uncomment this part and command the next for
    # loop:
    ## for tile_id in 0...@tileset.priorities.xsize
    ##  next if @tileset.priorities[tile_id] == 0
    ##  @priority_ids[tile_id] = @tileset.priorities[tile_id]
    ## end
    # But because we don't have that data, just iterate trough the map and
    # get seperate priority data for each tile, and save if there is one.
    for z in 0...3
      for y in 0...map_tile_height
        for x in 0...map_tile_width
          next if (id = tile_id(x, y, z)) == 0
          next if (p = priority(id)) == 0
          @priority_ids[id] = p
        end
      end
    end
    # Draw if allowed
    draw_region if @can_draw and @priorities and @tileset
  end
  #--------------------------------------------------------------------------
  # * Redraw autotiles (on change)
  #--------------------------------------------------------------------------
  def redraw_autotiles
    # Clear autotile bitmaps
    @auto_tiles.clear
    # Dispose current autotiles on screen
    @autotile_sprites.each { |sprite| sprite[0].dispose if !sprite[0].disposed? }
    # Get rid of disposed sprites
    @autotile_sprites.clear
    # Save changes aka don't call this method again
    @oldautotiles = @autotiles
    # Draw if allowed
    draw_region if @can_draw and @priorities and @tileset
  end
  #--------------------------------------------------------------------------
  # * Draw new Visible region
  #--------------------------------------------------------------------------
  def draw_current_region
    # Determine x and y coords for tile top left
    left_x = @ox / 32
    top_y = @oy / 32
    # Set origin for bitmap
    @sprite.ox = @ox % 32 + BitmapWindowOffset * 32
    @sprite.oy = @oy % 32 + BitmapWindowOffset * 32
    # Set New Region
    @region.x, @region.y = left_x, top_y
    # Set New Sprite Positions (pray for non disposed sprites: checking = cpu cost)
    (@priority_sprites + @autotile_sprites).each { |sprite| sprite[0].x = (sprite[1] - left_x) * 32 ; 
      sprite[0].ox = @ox % 32; sprite[0].y = (sprite[2] - top_y) * 32; sprite[0].oy = @oy % 32;
      unless (priority = @priority_ids[tile_id(sprite[1], sprite[2], sprite[3])]).nil? then sprite[0].z = @viewport.z + sprite[0].y + priority * 32 + 32 end}
    # Return on old data
    return if @oldregion == @region
    # Draw complete region if new?
    return draw_region if @oldregion.nil?
    # Determine missing rect
    first_drawing_x = [((left_x - @oldregion.x) >= 0 ? @region.width : 0) - (left_x - @oldregion.x)].max
    drawing_rect_x = Rect.new(first_drawing_x, 0, ((left_x - @oldregion.x).abs), @region.height)
    first_drawing_y = [((top_y - @oldregion.y) >= 0 ? @region.height : 0) - (top_y - @oldregion.y)].max
    drawing_rect_y = Rect.new(0, first_drawing_y, @region.width, ((top_y - @oldregion.y).abs))
    # Determine Rect that is still visible
    stay_rect = Rect.new([(left_x-@oldregion.x) * 32,0].max, [(top_y-@oldregion.y) * 32,0].max, (@region.width - (left_x-@oldregion.x).abs) * 32,(@region.height - (top_y-@oldregion.y).abs) * 32)
    # Dumplicate bitmap and clear Original
    dump_bitmap = sprite_bitmap.dup; sprite_bitmap.clear
    # Place Old bitmap on screen
    sprite_bitmap.blt([(@oldregion.x-left_x) * 32, 0].max, [(@oldregion.y-top_y) * 32, 0].max,dump_bitmap, stay_rect)
    # Remove Out of Range Sprites
    if KillOutScreenSprite
      _prio, _auto = @priority_sprites.dup, @autotile_sprites.dup; @priority_sprites, @autotile_sprites = [], []
      for sprite in _prio do if (sprite[1]) < @region.x - BitmapWindowOffset or (sprite[1] - BitmapWindowOffset) > @region.width + @region.x or sprite[2] < @region.y - BitmapWindowOffset or (sprite[2] - BitmapWindowOffset) > @region.height + @region.y  then sprite[0].dispose else @priority_sprites << sprite end end
      for sprite in _auto do if (sprite[1]) < @region.x - BitmapWindowOffset or (sprite[1] - BitmapWindowOffset) > @region.width + @region.x or sprite[2] < @region.y - BitmapWindowOffset or (sprite[2] - BitmapWindowOffset) > @region.height + @region.y  then sprite[0].dispose else @autotile_sprites << sprite end end
      # Remove nil elements (error prevention)
      @priority_sprites.compact!; @autotile_sprites.compact!;
    end
    # Draw New Columns
    for x in 0...drawing_rect_x.width
      for y in 0...drawing_rect_x.height
        for z in 0..2
          draw_tile(drawing_rect_x.x + x , drawing_rect_x.y + y, tile_id(left_x + drawing_rect_x.x + x - BitmapWindowOffset, top_y + y - BitmapWindowOffset, z), left_x + drawing_rect_x.x + x - BitmapWindowOffset, top_y + y - BitmapWindowOffset, z)
        end
      end
    end
    # Draw New Rows
    for x in 0...drawing_rect_y.width
      for y in 0...drawing_rect_y.height
        for z in 0..2
          draw_tile(drawing_rect_y.x + x , drawing_rect_y.y + y, tile_id(left_x + x - BitmapWindowOffset, top_y + drawing_rect_y.y + y - BitmapWindowOffset, z), left_x + x - BitmapWindowOffset, top_y + drawing_rect_y.y + y - BitmapWindowOffset, z)
        end
      end
    end
    # Set region sprite coords
    @oldregion = Rect.new(left_x, top_y, @region.width, @region.height)
  end
  #--------------------------------------------------------------------------
  # * Draw complete visible region
  #--------------------------------------------------------------------------
  def draw_region
    # Clear Sprites
    sprite_bitmap.clear
    (@priority_sprites + @autotile_sprites).each { |sprite| sprite[0].dispose }
    @priority_sprites.clear; @autotile_sprites.clear
    # Determine x and y coords for tile top left
    left_x = @ox / 32
    top_y = @oy / 32 
    # Set Sprite ox/oy
    @sprite.ox = BitmapWindowOffset * 32
    @sprite.oy = BitmapWindowOffset * 32
    # Set New Region
    @region.x, @region.y = left_x, top_y
    # Iterate through new xses
    for x in 0...(@region.width)
      for y in 0...(@region.height)
        for z in 0..2
          # Draw new tiles
          draw_tile(x, y , tile_id(x + left_x - BitmapWindowOffset,y + top_y - BitmapWindowOffset,z), x + left_x - BitmapWindowOffset , y + top_y - BitmapWindowOffset, z)
        end
      end
    end
    # Set oldregion (sprite coords)
    @oldregion = Rect.new(left_x, top_y, @region.width, @region.height)
    # Update Sprite
    @sprite.update
    # Prevent Frame Skipping
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Draw a tile
  #     x       : x coord in tiles on screen
  #     y       : y coord in tiles on screen
  #     tile_id : tile id
  #     tx      : x coord in tiles on map
  #     ty      : y coord in tiles on map
  #     tx      : z layer on map
  #     src_... : bitmap to draw on
  #--------------------------------------------------------------------------
  def draw_tile(x, y, tile_id, tx, ty, tz, src_bitmap = nil)
    # Return on invalid data
    #return if @region.x < x or @region.y < y
    #return if @region.width + @region.x > x or @region.height + @region.y > y
    return if x < 0 or y < 0
    return if tile_id == nil
    return draw_autotile(x, y, tile_id, tx, ty, tz, bitmap = bitmap) if tile_id < 384
    # First, Get Bitmap
    if (src_bitmap = @normal_tiles[tile_id]).nil?
      # Get Bitmap
      src_bitmap = Bitmap.new(32, 32)
      src_rect = Rect.new((tile_id - 384) % 8 * 32, (tile_id - 384) / 8 * 32,32,32)
      src_bitmap.blt(0, 0, @tileset, src_rect)
      # Save Bitmap
      @normal_tiles[tile_id] = src_bitmap
    end
    # Now, if tile is not a priority tile...
    if @priority_ids[tile_id].nil?
      sprite_bitmap.blt(x * 32, y * 32, src_bitmap, Rect.new(0,0,32,32))
    else
      # ... Set Sprite and bitmap
      sprite = Sprite.new(@viewport)
      sprite.visible = visible
      sprite.bitmap = src_bitmap
      sprite.x, sprite.y = (tx - (@ox/32)) * 32, (ty - (@oy/32)) * 32
      sprite.ox, sprite.oy = @ox % 32, @oy % 32
      # Priority matches 32 (above normal) + value * 32 (priority) + tile y * 32
      sprite.z = @viewport.z + y * 32 + @priority_ids[tile_id] * 32 + 32
      # Add to sprites Array
      @priority_sprites << [sprite, tx, ty, tz]
    end
  end
  #--------------------------------------------------------------------------
  # * Draw an autotile
  #     x       : x coord in tiles on screen
  #     y       : y coord in tiles on screen
  #     tile_id : tile id
  #     tx      : x coord in tiles on map
  #     ty      : y coord in tiles on map
  #     tx      : z layer on map
  #     src_... : bitmap to draw on
  #--------------------------------------------------------------------------
  def draw_autotile(x, y, tile_id, tx, ty, tz, src_bitmap = nil)
    # Kill invalid calls
    return if x < 0 or y < 0
    return if tile_id == nil or tile_id >= 384
    return if tile_id == 0
    # Get AutotileGraphic
    autotile = @autotiles[tile_id/48-1]
    return if autotile.nil? or autotile.disposed?
    # Get Frame Data
    frames = (autotile.height == 32 ? autotile.width / 32 : autotile.width / 96)
    current_frame = (Graphics.frame_count/AutotileLength) % frames
    # First Get Bitmap
    if (src_bitmap_array = @auto_tiles[tile_id]).nil?
      @auto_tiles[tile_id] = []
      # If autotile is weird... :P
      if autotile.height == 32
        # Just iterate trough frames
        for i in 0...frames
          # Create a bitmap for this frame
          this_frame_bitmap = Bitmap.new(32,32)
          src_rect = Rect.new(i * 32, 0, 32, 32)
          this_frame_bitmap.blt(0, 0, autotile, src_rect)
          # Save this frame's bitmap
          @auto_tiles[tile_id] << this_frame_bitmap
        end
        # Set the bitmap array to the created one
        src_bitmap_array = @auto_tiles[tile_id]
      else
        # If autotile is normal, iterate
        for i in 0...frames
          # Create a new bitmap for this frame
          this_frame_bitmap = Bitmap.new(32,32)
          # Get the tiles from the Autotiles Array (tile_id corresponds
          # to the autotile graphic, so left_top is different to center
          tiles = Autotiles[(tile_id % 48)>>3][(tile_id % 48)&7]
          # Iterate trough 0, 1, 2 and 3
          for j in 0...4
            # Get tile_position (to get from the graphic)
            tile_position = tiles[j] - 1
            src_rect = Rect.new(tile_position % 6 * 16 + i * 96, tile_position / 6 * 16, 16, 16)
            this_frame_bitmap.blt(j % 2 * 16, j / 2 * 16 , autotile, src_rect)
          end
          @auto_tiles[tile_id][i] = this_frame_bitmap
        end
        src_bitmap_array = @auto_tiles[tile_id]
      end
    end
    # Now Get Frame Bitmap
    src_bitmap = src_bitmap_array[current_frame]
    return if src_bitmap.nil?
    # Now, if tile is not a priority tile...
    if @priority_ids[tile_id].nil? and autotile.width == 32
      sprite_bitmap.blt(x * 32, y * 32, src_bitmap, Rect.new(0,0,32,32))
    else
      priority = (@priority_ids[tile_id] or 0)
      # ... Set Sprite and bitmap
      sprite = Sprite.new(@viewport)
      sprite.visible = visible
      sprite.bitmap = src_bitmap
      sprite.x, sprite.y = (tx - (@ox/32)) * 32, (ty - (@oy/32)) * 32
      sprite.ox, sprite.oy = @ox % 32, @oy % 32
      # Priority matches 32 (above normal) + value * 32 (priority) + tile y * 32
      # Because this sprite is created later then the normal base sprite, it
      # has a higher internal z value. We fix this by setting the z value to
      # minus 2 + z value of this tile. This results in that a autotile is below
      # minus 2 + z value of this tile. This results in that a autotile is below
      # a normal sprite on the same priority
      sprite.z = @viewport.z - 2 + tz # Fix for ltr drwn.
      unless @priority_ids[tile_id].nil?
        sprite.z = @viewport.z + y * 32 + @priority_ids[tile_id] * 32 + 32
      end
      # Add to sprites Array
      @autotile_sprites << [sprite, tx, ty, tz]
    end
  end
  #--------------------------------------------------------------------------
  # * Get new autotile Bitmap
  #     tile_id : tile id
  #--------------------------------------------------------------------------
  def get_update_autotile(tile_id)
    # Kill invalid Data
    return if tile_id == nil or tile_id >= 384
    return if tile_id == 0
    # Get AutotileGraphic
    autotile = @autotiles[tile_id/48-1]
    return if autotile.nil? or autotile.disposed?
    # Get Frame Data
    frames = (autotile.height == 32 ? autotile.width / 32 : autotile.width / 96)
    current_frame = (Graphics.frame_count/AutotileLength) % frames
    # Now Get Frame Bitmap
    src_bitmap = @auto_tiles[tile_id][current_frame]
    return src_bitmap    
  end
  #--------------------------------------------------------------------------
  # * Set x origin value
  #     value : new value
  #--------------------------------------------------------------------------
  def ox=(value)
    # Next line is needed if you want to do complex things if ox changes
    return unless @ox != value
    @ox = value
  end
  #--------------------------------------------------------------------------
  # * Set y origin value
  #     value : new value
  #--------------------------------------------------------------------------
  def oy=(value)
    # Next line is needed if you want to do complex things if oy changes
    return unless @oy != value
    @oy = value
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Redraw autotiles if changed
    redraw_autotiles if autotiles_changed?
    # Cancel updating if invisible
    return if not visible?
    # Flash Tiles
    update_flashing if flashing?
    # Update autotiles
    update_autotiles if (Graphics.frame_count % AutotileLength) == 0
    # Draw Region
    draw_current_region
  end
  #--------------------------------------------------------------------------
  # * Update (flashing)
  #--------------------------------------------------------------------------
  def update_flashing
    # To be released
  end
  #--------------------------------------------------------------------------
  # * Update (autotiles)
  #--------------------------------------------------------------------------
  def update_autotiles
    # Determine x and y coords for tile top left
    left_x = @ox / 32
    top_y = @oy / 32 
    # Iterate trough sprites
    for sprite in @autotile_sprites
      # Get Data from Array
      real_sprite, tx, ty, tz = sprite
      tile_id = tile_id(tx, ty, tz)
      # Replace Bitmap (can't clear the bitmap, for some reason - don't try to)
      real_sprite.bitmap = get_update_autotile(tile_id)
      # We do not need to update the positions already, because it will be done
      # the next method call (below update_autotiles, there is draw_current_...)
      # so it will be 'fixed' there. No need to call something twice, right?
    end
  end
  
end