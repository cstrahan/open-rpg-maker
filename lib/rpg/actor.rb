require 'table'

module RPG
  class Actor
    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @final_level = 99
      @exp_basis = 30
      @exp_inflation = 30
      @character_name = ""
      @character_hue = 0
      @battler_name = ""
      @battler_hue = 0
      @parameters = Table.new(6,100)
      for i in 1..99
        @parameters[0,i] = 500+i*50
        @parameters[1,i] = 500+i*50
        @parameters[2,i] = 50+i*5
        @parameters[3,i] = 50+i*5
        @parameters[4,i] = 50+i*5
        @parameters[5,i] = 50+i*5
      end
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @weapon_fix = false
      @armor1_fix = false
      @armor2_fix = false
      @armor3_fix = false
      @armor4_fix = false
    end
    
    # The actor ID.
    attr_accessor :id
    
    # The actor name.
    attr_accessor :name
    
    # The actor class ID.
    attr_accessor :class_id
    
    # The actor's initial level.
    attr_accessor :initial_level
    
    # The actor's final level.
    attr_accessor :final_level
    
    # The value on which the experience curve is based (10..50).
    attr_accessor :exp_basis
    
    # The amount of experience curve inflation (10..50).
    attr_accessor :exp_inflation
    
    # The actor's character graphic file name.
    attr_accessor :character_name
    
    # The adjustment value for the character graphic's hue (0..360).
    attr_accessor :character_hue
    
    # The actor's battler graphic file name.
    attr_accessor :battler_name
       
    # The adjustment value for the battler graphic's hue (0..360).
    attr_accessor :battler_hue
    
    # 2-dimensional {Table} containing base parameters for each level.
    #
    # Generally takes the form parameters[kind, level].
    #
    # kind indicates the parameter type:
    # 0::   max HP
    # 1::   max SP
    # 2::   strength
    # 3::   dexterity
    # 4::   agility
    # 5::   intelligence).
    # @returns [Table]
    attr_accessor :parameters
    
    # ID of the actor's initially equipped weapon.
    attr_accessor :weapon_id

    # ID of the actor's initially equipped shield.
    attr_accessor :armor1_id

    # ID of the actor's initially equipped helmet.
    attr_accessor :armor2_id
    
    # ID of the actor's initially equipped body armor.
    attr_accessor :armor3_id
    
    # ID of the actor's initially equipped accessory.
    attr_accessor :armor4_id
    
    # Flag making the actor's weapon unremovable.
    attr_accessor :weapon_fix
    
    # Flag making the actor's shield unremovable.
    attr_accessor :armor1_fix
    
    # Flag making the actor's helmet unremovable.
    attr_accessor :armor2_fix
    
    # Flag making the actor's body armor unremovable.
    attr_accessor :armor3_fix
    
    # Flag making the actor's accessory unremovable.
    attr_accessor :armor4_fix
  end
end
