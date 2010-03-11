require 'rpg/audio_file'

module RPG
  class Map
    def initialize(width, height)
      @tileset_id = 1
      @width = width
      @height = height
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @encounter_list = []
      @encounter_step = 30
      @data = Table.new(width, height, 3)
      @events = {}
    end
    
    # Tileset ID to be used in the map.
    attr_accessor :tileset_id
    
    # The map width.
    attr_accessor :width
    
    # The map height.
    attr_accessor :height
    
    # Truth-value of whether BGM autoswitching is enabled.
    attr_accessor :autoplay_bgm
    
    # If BGM autoswitching is enabled, the name of that BGM ({RPG::AudioFile}).
    attr_accessor :bgm
    
    # Truth-value of whether BGS autoswitching is enabled.
    attr_accessor :autoplay_bgs
    
    # If BGS autoswitching is enabled, the name of that BGS ({RPG::AudioFile}).
    attr_accessor :bgs

    # Encounter list. A troop ID array.
    attr_accessor :encounter_list
    
    # Number of steps between encounters.
    attr_accessor :encounter_step
    
    # The map data. A 3-dimensional tile ID {Table}.
    attr_accessor :data
    
    # Map events. A hash that represents {RPG::Event} instances as values,
    # using event IDs as the keys.
    attr_accessor :events
  end
end