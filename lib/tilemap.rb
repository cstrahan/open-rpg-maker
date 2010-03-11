# The class governing tilemaps. Tilemaps are a specialized concept used in 2D
# game map displays, created internally from multiple sprites.
class Tilemap
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
  attr_accessor :map_data
  
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

  def initialize(viewport = nil)
    raise "not implemented"
    
    @viewport = viewport
  end

  # Frees the tilemap. If the tilemap has already been freed, does nothing.
  def disposed()
    raise "not implemented"
    
    @disposed = true
  end

  # Returns TRUE if the tilemap has been freed.
  def disposed?()
    @disposed
  end
end