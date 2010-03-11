require 'move_route'

module RPG
  class Event
    # The event ID.
    attr_accessor :id
    
    # The event name.
    attr_accessor :name
    
    # The event's X-coordinate on the map.
    attr_accessor :x
    
    # The event's Y-coordinate on the map.
    attr_accessor :y
    
    # The Events pages. An {RPG::Event::Page} array.
    # @returns [Array<RPG::Event::Page>]
    attr_accessor :pages

    def initialize(x, y)
      @id = 0
      @name = ""
      @x = x
      @y = y
      @pages = [RPG::Event::Page.new]
    end

    # Data class for the event page.
    class Page
      def initialize
        @condition = RPG::Event::Page::Condition.new
        @graphic = RPG::Event::Page::Graphic.new
        @move_type = 0
        @move_speed = 3
        @move_frequency = 3
        @move_route = RPG::MoveRoute.new
        @walk_anime = true
        @step_anime = false
        @direction_fix = false
        @through = false
        @always_on_top = false
        @trigger = 0
        @list = [RPG::EventCommand.new]
      end
      
      # The event condition {RPG::Event::Page::Condition}.
      # @returns [RPG::Event::Page::Condition]
      attr_accessor :condition
      
      # The event graphic {RPG::Event::Page::Graphic}.
      # @returns [RPG::Event::Page::Graphic]
      attr_accessor :graphic
      
      # Type of movement: 
      # 0::    fixed
      # 1::    random
      # 2::    approach
      # 3::    custom
      attr_accessor :move_type
      
      # Movement speed:
      # 1::    slowest
      # 2::    slower
      # 3::    slow
      # 4::    fast
      # 5::    faster
      # 6::    fastest
      attr_accessor :move_speed
      
      # Movement frequency:
      # 1::    lowest
      # 2::    lower
      # 3::    low
      # 4::    high
      # 5::    higher
      # 6::    highest
      attr_accessor :move_frequency
      
      # Movement route (RPG::MoveRoute).
      # Referenced only when the movement type is set to Custom.
      attr_accessor :move_route
      
      # Truth value of the [Moving Animation] option.
      attr_accessor :walk_anime
      
      # Truth value of the [Stopped Animation] option.
      attr_accessor :step_anime
      
      # Truth value of the [Fixed Direction] option.
      attr_accessor :direction_fix
      
      # Truth value of the [Move Through] option.
      attr_accessor :through
      
      # Truth value of the [Always On Top] option.
      attr_accessor :always_on_top
      
      # Event trigger:
      # 0::    action button
      # 1::     contact with player
      # 2::     contact with event
      # 3::     autorun
      # 4::     parallel processing
      attr_accessor :trigger
      
      # Program contents. An {RPG::EventCommand} array.
      # @returns [Array<RPG::EventCommand>]
      attr_accessor :list
      
      class Condition
        def initialize
          @switch1_valid = false
          @switch2_valid = false
          @variable_valid = false
          @self_switch_valid = false
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
        end
        
        # Truth value for whether the first [Switch] condition is valid.
        attr_accessor :switch1_valid
        
        # Truth value for whether the second [Switch] condition is valid.
        attr_accessor :switch2_valid
        
        # Truth value for whether the [Variable] condition is valid.
        attr_accessor :variable_valid
        
        Truth value for whether the [Self Switch] condition is valid.
        attr_accessor :self_switch_valid
        
        # If the first [Switch] condition is valid, the ID of that switch.
        attr_accessor :switch1_id
        
        # If the second [Switch] condition is valid, the ID of that switch.
        attr_accessor :switch2_id
        
        # If the [Variable] condition is valid, the ID of that variable.
        attr_accessor :variable_id
        
        # If the [Variable] condition is valid,
        # the standard value of that variable (x and greater).
        attr_accessor :variable_value
        
        # If the [Self Switch] condition is valid,
        # the letter of that self switch ("A".."D").
        attr_accessor :self_switch_ch
      end
      
      # Data class for the Event page [Graphics].
      class Graphic
        def initialize
          @tile_id = 0
          @character_name = ""
          @character_hue = 0
          @direction = 2
          @pattern = 0
          @opacity = 255
          @blend_type = 0
        end
        
        # The tile ID. If the specified graphic is not a tile, this value is 0.
        attr_accessor :tile_id
        
        # The character's graphic file name.
        attr_accessor :character_name
        
        # The adjustment value for the character graphic's hue (0..360).
        attr_accessor :character_hue
        
        # The direction in which the character is facing
        # 2::    down
        # 4::    left
        # 6::    right
        # 8::    up
        attr_accessor :direction
        
        # The character's pattern (0..3).
        attr_accessor :pattern
        
        # The character's opacity.
        attr_accessor :opacity
        
        # The character's blending mode.
        attr_accessor :blend_type
      end
    end
  end
end