require 'rpg/audio_file'

module RPG
  class Animation
    def initialize
      @id = 0
      @name = ""
      @animation_name = ""
      @animation_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end
    
    # The animation ID.
    attr_accessor :id
    
    # The animation name.
    attr_accessor :name
    
    # The animation's graphic file name.
    attr_accessor :animation_name
    
    # The adjustment value for the animation graphic's hue (0..360).
    attr_accessor :animation_hue
    
    # The animation's position:
    # 0:: top
    # 1:: middle
    # 2:: bottom
    # 3:: screen
    attr_accessor :position
    
    # Number of frames.
    attr_accessor :frame_max
    
    # Frame contents. An RPG::Animation::Frame array.
    # @return [Array<RPG::Animation::Frame>]
    attr_accessor :frames
    
    # Timing for SE and flash effects. An {RPG::Animation::Timing} array.
    # @return [Array<RPG::Animation::Timing>]
    attr_accessor :timings
    
    # Data class for animation frames.
    class Frame
      def initialize
        @cell_max = 0
        @cell_data = Table.new(0, 0)
      end
      
      # Number of cells. Equivalent to the largest cell number in the frame set.
      attr_accessor :cell_max
      
      # 2-dimensional array containing cell contents (Table).
      #
      # Generally takes the form cell_data[cell_index, data_index].
      #
      # data_index ranges from 0 to 7 and denotes various 
      # information about a cell:
      # 0::    pattern
      # 1::    X-coordinate
      # 2::    Y-coordinate
      # 3::    zoom level
      # 4::    angle of rotation
      # 5::    horizontal flip
      # 6::    opacity
      # 7::    blending mode
      #
      # Patterns are 1 less than the number displayed in RPGXP;
      # -1 indicates that that cell is not in use.
      attr_accessor :cell_data
    end
    
    # Data class for the timing of an animation's SE and flash effects.
    class Timing
      def initialize
        @frame = 0
        @se = RPG::AudioFile.new("", 80)
        @flash_scope = 0
        @flash_color = Color.new(255,255,255,255)
        @flash_duration = 5
        @condition = 0
      end
      
      # Frame number. 1 less than the number displayed in RPGXP.
      attr_accessor :frame
      
      # SE, or sound effect (RPG::AudioFile).
      attr_accessor :se
      
      # Flash area:
      # 0::    none
      # 1::    target 
      # 2::    screen
      # 3::    delete target
      attr_accessor :flash_scope
      
      # Flash {Color}.
      attr_accessor :flash_color
      
      # Flash duration.
      attr_accessor :flash_duration
      
      # Condition of the effect:
      # 0::    none
      # 1::    hit
      # 2::    miss
      attr_accessor :condition
    end
  end
end