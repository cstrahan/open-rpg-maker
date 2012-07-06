module RPG
  # Data class for state.
  class State
    def initialize
      @id = 0
      @name = ""
      @animation_id = 0
      @restriction = 0
      @nonresistance = false
      @zero_hp = false
      @cant_get_exp = false
      @cant_evade = false
      @slip_damage = false
      @rating = 5
      @hit_rate = 100
      @maxhp_rate = 100
      @maxsp_rate = 100
      @str_rate = 100
      @dex_rate = 100
      @agi_rate = 100
      @int_rate = 100
      @atk_rate = 100
      @pdef_rate = 100
      @mdef_rate = 100
      @eva = 0
      @battle_only = true
      @hold_turn = 0
      @auto_release_prob = 0
      @shock_release_prob = 0
      @guard_element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    # State ID.
    attr_accessor :id

    # State name.
    attr_accessor :name

    # The state's animation ID.
    attr_accessor :animation_id

    # Sets restrictions:
    # 0::    none
    # 1::    can't use magic
    # 2::    always attack enemies
    # 3::    always attack allies
    # 4::    can't move
    attr_accessor :restriction

    # Truth value of the [Nonresistance] option.
    attr_accessor :nonresistance

    # Truth value of the [Regard as HP 0] option.
    attr_accessor :zero_hp

    # Truth value of the [Can't Get EXP] option.
    attr_accessor :cant_get_exp

    # Truth value of the [Can't Evade] option.
    attr_accessor :cant_evade

    # Truth value of the [Slip Damage] option.
    attr_accessor :slip_damage

    # State rating (0..10).
    attr_accessor :rating

    # Hit percentage.
    attr_accessor :hit_rate

    # Maximum HP percentage.
    attr_accessor :maxhp_rate

    # Maximum SP percentage.
    attr_accessor :maxsp_rate

    # Strength percentage.
    attr_accessor :str_rate

    # Dexterity percentage.
    attr_accessor :dex_rate

    # Agility percentage.
    attr_accessor :agi_rate

    # Intelligence percentage.
    attr_accessor :int_rate

    # Attack percentage.
    attr_accessor :atk_rate

    # Physical defense percentage.
    attr_accessor :pdef_rate

    # Magic defense percentage.
    attr_accessor :mdef_rate

    # Evasion correction.
    attr_accessor :eva

    # Truth value of whether the state wears off at battle end.
    attr_accessor :battle_only

    attr_accessor :hold_turn

    # Percent probability of wearing off after the number of turns
    # in hold_turn have passed.
    attr_accessor :auto_release_prob

    # Percent probability of wearing off after receiving physical damage.
    attr_accessor :shock_release_prob

    # Elemental defense. An Elemental ID array.
    attr_accessor :guard_element_set

    # States to add. A State ID array.
    attr_accessor :plus_state_set

    # States to cancel. A State ID array.
    attr_accessor :minus_state_set
  end
end
