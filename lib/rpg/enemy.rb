require 'table'

module RPG
  class Enemy
    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 500
      @maxsp = 500
      @str = 50
      @dex = 50
      @agi = 50
      @int = 50
      @atk = 100
      @pdef = 100
      @mdef = 100
      @eva = 0
      @animation1_id = 0
      @animation2_id = 0
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @exp = 0
      @gold = 0
      @item_id = 0
      @weapon_id = 0
      @armor_id = 0
      @treasure_prob = 100
    end
    
    # The enemy ID.
    attr_accessor :id
    
    # The enemy name.
    attr_accessor :name
    
    # The enemy's battler graphic file name.
    attr_accessor :battler_name
    
    # The adjustment value for the battler graphic's hue (0..360).
    attr_accessor :battler_hue
    
    # The enemy's max HP.
    attr_accessor :maxhp
    
    # The enemy's max SP.
    attr_accessor :maxsp
    
    # The enemy's strength.
    attr_accessor :str
    
    # The enemy's dexterity.
    attr_accessor :dex
    
    # The enemy's agility.
    attr_accessor :agi
    
    # The enemy's intelligence.
    attr_accessor :int
    
    # The enemy's attack power.
    attr_accessor :atk
    
    # The enemy's physical defense rating.
    attr_accessor :pdef
    
    # The enemy's magic defense rating.
    attr_accessor :mdef
    
    # The enemy's evasion rating.
    attr_accessor :eva
    
    # The battle animation ID.
    attr_accessor :animation1_id
    
    # The target animation ID.
    attr_accessor :animation2_id
    
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
    
    # The enemy's actions. An {RPG::Enemy::Action} array.
    # @returns [Array<RPG::Enemy::Action>]
    attr_accessor :actions
    
    # The enemy's experience.
    attr_accessor :exp
    
    # The enemy's gold.
    attr_accessor :gold
    
    # The ID of the item used as treasure.
    attr_accessor :item_id
    
    # The ID of the weapon used as treasure.
    attr_accessor :weapon_id
    
    # The ID of the armor used as treasure.
    attr_accessor :armor_id
    
    # The probability of treasure being left behind.
    attr_accessor :treasure_prob

    class Action
      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_turn_a = 0
        @condition_turn_b = 1
        @condition_hp = 100
        @condition_level = 1
        @condition_switch_id = 0
        @rating = 5
      end
      
      # Type of action:
      # 0::    basic
      # 1::    skill
      attr_accessor :kind
      
      # When set to a [Basic] action, defines it further:
      # 0::    attack
      # 1::    defend
      # 2::    escape
      # 3::    do nothing
      attr_accessor :basic
      
      # When set to a [Skill], the ID of that skill.
      attr_accessor :skill_id
      
      # a value specified in the [Turn] condition.
      # To be input in the form a + bx.
      #
      # When the turn is not specified as a condition, a = 0 and b = 1.
      attr_accessor :condition_turn_a
      
      # b value specified in the [Turn] condition.
      # To be input in the form a + bx.
      #
      # When the turn is not specified as a condition, a = 0 and b = 1.
      attr_accessor :condition_turn_b
      
      # Percentage specified in the [HP] condition.
      #
      # When HP is not specified as a condition, this value is set to 100.
      attr_accessor :condition_hp
      
      # Standard level specified in the [Level] condition.
      #
      # When the level is not specified as a condition, this value is set to 1.
      attr_accessor :condition_level
      
      # Switch ID specified in the [Switch] condition.
      #
      # When the switch ID is not specified as a condition,
      # this value is set to 0. Consequently, it is essential to check whether
      # this value is 0.
      attr_accessor :condition_switch_id
      
      # The action's rating (1..10).
      attr_accessor :rating
    end
  end
end
