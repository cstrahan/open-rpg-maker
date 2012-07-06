module RPG
  # Data class for weapons.
  class Weapon
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @animation1_id = 0
      @animation2_id = 0
      @price = 0
      @atk = 0
      @pdef = 0
      @mdef = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    # The weapon ID.
    attr_accessor :id

    # The weapon name.
    attr_accessor :name

    # The weapon's icon graphic file name.
    attr_accessor :icon_name

    # The weapon description.
    attr_accessor :description

    # The animation ID when using the weapon.
    attr_accessor :animation1_id

    # The animation ID when on the receiving end of the weapon.
    attr_accessor :animation2_id

    # The weapon's price.
    attr_accessor :price

    # The weapon's attack power.
    attr_accessor :atk

    # The weapon's physical defense rating.
    attr_accessor :pdef

    # The weapon's magic defense rating.
    attr_accessor :mdef

    # The weapon's strength bonus.
    attr_accessor :str_plus

    # The weapon's dexterity bonus.
    attr_accessor :dex_plus

    # The weapon's agility bonus.
    attr_accessor :agi_plus

    # The weapon's intelligence bonus.
    attr_accessor :int_plus

    # The weapon's element. An Elemental ID array.
    attr_accessor :element_set

    # States to add. A State ID array.
    attr_accessor :plus_state_set

    # States to cancel. A State ID array.
    attr_accessor :minus_state_set
  end
end
