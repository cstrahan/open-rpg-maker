require 'table'

module RPG
  # Data class for tilesets.
  class Tileset
    def initialize
      @id = 0
      @name = ""
      @tileset_name = ""
      @autotile_names = [""]*7
      @panorama_name = ""
      @panorama_hue = 0
      @fog_name = ""
      @fog_hue = 0
      @fog_opacity = 64
      @fog_blend_type = 0
      @fog_zoom = 200
      @fog_sx = 0
      @fog_sy = 0
      @battleback_name = ""
      @passages = Table.new(384)
      @priorities = Table.new(384)
      @priorities[0] = 5
      @terrain_tags = Table.new(384)
    end
    
    # The tileset ID.
    attr_accessor :id
    
    # The tileset name.
    attr_accessor :name
    
    # The tileset's graphic file name.
    attr_accessor :tileset_name
    
    # The autotile graphic's file name array ([0]..[6]).
    attr_accessor :autotile_names
    
    # The panorama graphic file name.
    attr_accessor :panorama_name
    
    # The adjustment value for the panorama graphic's hue (0..360).
    attr_accessor :panorama_hue
    
    # The fog graphic's file name.
    attr_accessor :fog_name
    
    # The adjustment value for the fog graphic's hue (0..360).
    attr_accessor :fog_hue
    
    # The fog's opacity.
    attr_accessor :fog_opacity
    
    # The fog's blending mode.
    attr_accessor :fog_blend_type
    
    # The fog's zoom level.
    attr_accessor :fog_zoom
    
    # The fog's SX (automatic X-axis scrolling speed).
    attr_accessor :fog_sx
    
    # The fog's SY (automatic Y-axis scrolling speed).
    attr_accessor :fog_sy
    
    # The battle background's graphic file name.
    attr_accessor :battleback_name
    
    # Passage table. A 1-dimensional {Table} containing passage flags, 
    # Bush flags, and counter flags.
    #
    # The tile ID is used as a subscript. Each bit is handled as follows:
    # 0x01::    Cannot move down. 
    # 0x02::    Cannot move left. 
    # 0x04::    Cannot move right. 
    # 0x08::    Cannot move up. 
    # 0x40::    Bush flag. 
    # 0x80::    Counter flag. 
    # @return [Table]
    attr_accessor :passages
    
    # Priority table. A 1-dimensional {Table} containing priority data.
    #
    # The tile ID is used as a subscript.
    # @return [Table]
    attr_accessor :priorities
    
    # Terrain tag table A 1-dimensional {Table} containing terrain tag data.
    #
    # The tile ID is used as a subscript.
    # @return [Table]
    attr_accessor :terrain_tags
  end
end