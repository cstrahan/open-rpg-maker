module RPG
  class Armor
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @kind = 0
      @auto_state_id = 0
      @price = 0
      @pdef = 0
      @mdef = 0
      @eva = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @guard_element_set = []
      @guard_state_set = []
    end
    
    # The armor ID.
    attr_accessor :id
    
    # The armor name.
    attr_accessor :name
    
    # The armor's icon graphic file name.
    attr_accessor :icon_name
    
    # The armor description.
    attr_accessor :description
    
    # Type of armor:
    # 0::    shield
    # 1::    helmet
    # 2::    body armor
    # 3::    accessory
    attr_accessor :kind
    
    # The auto state ID.
    attr_accessor :auto_state_id
    
    # The armor's price.
    attr_accessor :price
    
    # The armor's physical defense rating.
    attr_accessor :pdef
    
    # The armor's magic defense rating.
    attr_accessor :mdef
    
    # The armor's evasion correction.
    attr_accessor :eva
    
    # The armor's strength bonus.
    attr_accessor :str_plus
    
    # The armor's dexterity bonus.
    attr_accessor :dex_plus
    
    # The armor's agility bonus.
    attr_accessor :agi_plus
    
    # The armor's intelligence bonus.
    attr_accessor :int_plus
    
    # The armor's elemental defense rating. An elemental ID array.
    attr_accessor :guard_element_set
    
    # The armor's state defense rating. A state ID array.
    attr_accessor :guard_state_set
  end
end