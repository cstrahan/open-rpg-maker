module RPG
  class MapInfo
    def initialize
      @name = ""
      @parent_id = 0
      @order = 0
      @expanded = false
      @scroll_x = 0
      @scroll_y = 0
    end
    
    # The map name.
    attr_accessor :name
    
    # The parent map ID.
    attr_accessor :parent_id
    
    # The map tree display order, used internally.
    attr_accessor :order
    
    # The map tree expansion flag, used internally.
    attr_accessor :expanded
    
    # The X-axis scroll position, used internally.
    attr_accessor :scroll_x
    
    # The Y-axis scroll position, used internally.
    attr_accessor :scroll_y
  end
end