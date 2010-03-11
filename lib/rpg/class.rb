require 'table'

# Data class for class.
module RPG
  class Class
    # The class's ID.
    attr_accessor :id
    
    # The class name.
    attr_accessor :name
    
    # The class position:
    # 0::    front
    # 1::    middle
    # 2::    rear
    attr_accessor :position
    
    # Array containing IDs for equippable weapons.
    attr_accessor :weapon_set
    
    # Array containing IDs for equippable armor.
    attr_accessor :armor_set
    
    # Level of elemental effectiveness.
    # 1-dimensional {Table} using element IDs as subscripts, with 6 levels: 
    # 0::    A
    # 1::    B
    # 2::    C
    # 3::    D
    # 4::    E
    # 5::    F
    attr_accessor :element_ranks
    
    # Level of status effectiveness.
    # 1-dimensional {Table} using status IDs as subscripts, with 6 levels:
    # 0::    A
    # 1::    B
    # 2::    C
    # 3::    D
    # 4::    E
    # 5::    F
    attr_accessor :state_ranks
    
    # Skills to Learn. An {RPG::Class::Learning} array.
    # @return [Array<RPG::Class::Learning>]
    attr_accessor :learnings

    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
    end

    # Data class for a [Class's Learned] skills.
    class Learning
      # Skill level.
      attr_accessor :level
      
      # The learned skill's ID.
      attr_accessor :skill_id

      def initialize
        @level = 1
        @skill_id = 1
      end
    end
  end
end