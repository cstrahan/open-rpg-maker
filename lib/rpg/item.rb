require 'rpg/audio_file'

module RPG
  class Item
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 0
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @price = 0
      @consumable = true
      @parameter_type = 0
      @parameter_points = 0
      @recover_hp_rate = 0
      @recover_hp = 0
      @recover_sp_rate = 0
      @recover_sp = 0
      @hit = 100
      @pdef_f = 0
      @mdef_f = 0
      @variance = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    
    # The item ID.
    attr_accessor :id
    
    # The item name.
    attr_accessor :name
    
    # The item's icon graphic file name.
    attr_accessor :icon_name
    
    # The item description.
    attr_accessor :description
    
    # Scope of the item's effects:
    # 0::    none
    # 1::    one enemy
    # 2::    all enemies
    # 3::    one ally
    # 4::    all allies
    # 5::    1 ally--HP 0
    # 6::    all allies--HP 0
    # 7::    the user
    attr_accessor :scope
    
    # When the item may be used
    # 0::    always
    # 1::    only in battle
    # 2::    only from the menu
    # 3::    never
    attr_accessor :occasion
    
    # The animation ID when using the item.
    attr_accessor :animation1_id
    
    # The animation ID when on the receiving end of the item.
    attr_accessor :animation2_id
    
    # SE played when item is used on the menu screen (RPG::AudioFile).
    attr_accessor :menu_se
    
    # The Common Event ID.
    attr_accessor :common_event_id
    
    # The item price.
    attr_accessor :price
    
    # Truth value of whether the item disappears when used.
    attr_accessor :consumable
    
    # Parameter affected
    # 0::    none
    # 1::    max HP
    # 2::    max SP
    # 3::    strength
    # 4::    dexterity
    # 5::    agility
    # 6::    intelligence
    attr_accessor :parameter_type
    
    # Amount by which parameter increases.
    attr_accessor :parameter_points
    
    # HP recovery rate.
    attr_accessor :recover_hp_rate
    
    # HP recovery amount.
    attr_accessor :recover_hp
    
    # SP recovery rate.
    attr_accessor :recover_sp_rate
    
    # SP recovery amount.
    attr_accessor :recover_sp
    
    # The item's hit probability.
    attr_accessor :hit
    
    # The item's physical defense F rating.
    attr_accessor :pdef_f
    
    # The item's magic defense F rating.
    attr_accessor :mdef_f
    
    # The item's degree of variance.
    attr_accessor :variance
    
    # The item's element. An Elemental ID array.
    attr_accessor :element_set
    
    # States to add. A State ID array.
    attr_accessor :plus_state_set
    
    # States to cancel. A Stae ID array.
    attr_accessor :minus_state_set
  end
end
