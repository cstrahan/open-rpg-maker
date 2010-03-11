require 'audio_file'

module RPG
  # Data class for skills.
  class Skill
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 1
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @sp_cost = 0
      @power = 0
      @atk_f = 0
      @eva_f = 0
      @str_f = 0
      @dex_f = 0
      @agi_f = 0
      @int_f = 100
      @hit = 100
      @pdef_f = 0
      @mdef_f = 100
      @variance = 15
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    
    # The skill ID.
    attr_accessor :id
    
    # The skill name.
    attr_accessor :name
    
    # The skill's icon graphic file name.
    attr_accessor :icon_name
    
    # The skill description.
    attr_accessor :description
    
    # Scope of the skill's effects:
    # 0::    none
    # 1::    one enemy
    # 2::    all enemies
    # 3::    one ally
    # 4::    all allies
    # 5::    1 ally--HP 0
    # 6::    all allies--HP 0
    # 7::    the user
    attr_accessor :scope
    
    # When the skill may be used:
    # 0::    always
    # 1::    only in battle
    # 2::    only from the menu
    # 3::    never
    attr_accessor :occasion
    
    # The animation ID when using the skill.
    attr_accessor :animation1_id
    
    # The animation ID when on the receiving end of the skill.
    attr_accessor :animation2_id
    
    # SE played when skill is used on the menu screen {RPG::AudioFile}.
    attr_accessor :menu_se
    
    # The Common Event ID.
    attr_accessor :common_event_id
    
    # Number of SP consumed.
    attr_accessor :sp_cost
    
    # The skill's power.
    attr_accessor :power
    
    # The skill's attack power F rating.
    attr_accessor :atk_f
    
    # The skill's evasion F rating.
    attr_accessor :eva_f
    
    # The skill's strength F rating.
    attr_accessor :str_f
    
    # The skill's dexterity F rating.
    attr_accessor :dex_f
    
    # The skill's agility F rating.
    attr_accessor :agi_f
    
    # The skill's intelligence F rating.
    attr_accessor :int_f
    
    # The skill's hit probability.
    attr_accessor :hit
    
    # The skill's physical defense F rating.
    attr_accessor :pdef_f
    
    # The skill's magic defense F rating.
    attr_accessor :mdef_f
    
    # The skill's degree of variance.
    attr_accessor :variance
    
    # The skill's element. An Elemental ID array.
    attr_accessor :element_set
    
    # States to add. A State ID array.
    attr_accessor :plus_state_set
    
    # States to cancel. A State ID array.
    attr_accessor :minus_state_set
  end
end