#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :name                     # name
  attr_reader   :character_name           # character file name
  attr_reader   :character_hue            # character hue
  attr_reader   :class_id                 # class ID
  attr_reader   :weapon_id                # weapon ID
  attr_reader   :armor1_id                # shield ID
  attr_reader   :armor2_id                # helmet ID
  attr_reader   :armor3_id                # body armor ID
  attr_reader   :armor4_id                # accessory ID
  attr_reader   :level                    # level
  attr_reader   :exp                      # EXP
  attr_reader   :skills                   # skills
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    @hp = maxhp
    @sp = maxsp
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    # Learn skill
    for i in 1..@level
      for j in $data_classes[@class_id].learnings
        if j.level == i
          learn_skill(j.skill_id)
        end
      end
    end
    # Update auto state
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id])
  end
  #--------------------------------------------------------------------------
  # * Get Actor ID
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # * Get Index
  #--------------------------------------------------------------------------
  def index
    return $game_party.actors.index(self)
  end
  #--------------------------------------------------------------------------
  # * Calculate EXP
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..100
      if i > actor.final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Element Revision Value
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # Get values corresponding to element effectiveness
    table = [0,200,150,100,50,0,-100]
    result = table[$data_classes[@class_id].element_ranks[element_id]]
    # If this element is protected by armor, then it's reduced by half
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil and armor.guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # If this element is protected by states, then it's reduced by half
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # End Method
    return result
  end
  #--------------------------------------------------------------------------
  # * Get State Effectiveness
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_classes[@class_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # * Determine State Guard
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil
        if armor.guard_state_set.include?(state_id)
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Element
  #--------------------------------------------------------------------------
  def element_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.element_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (+)
  #--------------------------------------------------------------------------
  def plus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.plus_state_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack State Change (-)
  #--------------------------------------------------------------------------
  def minus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.minus_state_set : []
  end
  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 9999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 9999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_actors[@actor_id].parameters[0, @level]
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_actors[@actor_id].parameters[1, @level]
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.str_plus : 0
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    n += armor4 != nil ? armor4.str_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.dex_plus : 0
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    n += armor4 != nil ? armor4.dex_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.agi_plus : 0
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    n += armor4 != nil ? armor4.agi_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    n += armor4 != nil ? armor4.int_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.atk : 0
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    mdef1 = weapon != nil ? weapon.mdef : 0
    mdef2 = armor1 != nil ? armor1.mdef : 0
    mdef3 = armor2 != nil ? armor2.mdef : 0
    mdef4 = armor3 != nil ? armor3.mdef : 0
    mdef5 = armor4 != nil ? armor4.mdef : 0
    return mdef1 + mdef2 + mdef3 + mdef4 + mdef5
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  def base_eva
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    eva1 = armor1 != nil ? armor1.eva : 0
    eva2 = armor2 != nil ? armor2.eva : 0
    eva3 = armor3 != nil ? armor3.eva : 0
    eva4 = armor4 != nil ? armor4.eva : 0
    return eva1 + eva2 + eva3 + eva4
  end
  #--------------------------------------------------------------------------
  # * Get Offensive Animation ID for Normal Attacks
  #--------------------------------------------------------------------------
  def animation1_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation1_id : 0
  end
  #--------------------------------------------------------------------------
  # * Get Target Animation ID for Normal Attacks
  #--------------------------------------------------------------------------
  def animation2_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation2_id : 0
  end
  #--------------------------------------------------------------------------
  # * Get Class Name
  #--------------------------------------------------------------------------
  def class_name
    return $data_classes[@class_id].name
  end
  #--------------------------------------------------------------------------
  # * Get EXP String
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp.to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # * Get Next Level EXP String
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1].to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # * Get Until Next Level EXP String
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
      (@exp_list[@level+1] - @exp).to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # * Update Auto State
  #     old_armor : unequipped armor
  #     new_armor : equipped armor
  #--------------------------------------------------------------------------
  def update_auto_state(old_armor, new_armor)
    # Forcefully remove unequipped armor's auto state
    if old_armor != nil and old_armor.auto_state_id != 0
      remove_state(old_armor.auto_state_id, true)
    end
    # Forcefully add unequipped armor's auto state
    if new_armor != nil and new_armor.auto_state_id != 0
      add_state(new_armor.auto_state_id, true)
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Fixed Equipment
  #     equip_type : type of equipment
  #--------------------------------------------------------------------------
  def equip_fix?(equip_type)
    case equip_type
    when 0  # Weapon
      return $data_actors[@actor_id].weapon_fix
    when 1  # Shield
      return $data_actors[@actor_id].armor1_fix
    when 2  # Head
      return $data_actors[@actor_id].armor2_fix
    when 3  # Body
      return $data_actors[@actor_id].armor3_fix
    when 4  # Accessory
      return $data_actors[@actor_id].armor4_fix
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id    : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id, 1)
        @weapon_id = id
        $game_party.lose_weapon(id, 1)
      end
    when 1  # Shield
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 2  # Head
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 3  # Body
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 4  # Accessory
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.gain_armor(@armor4_id, 1)
        @armor4_id = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #     item : item
  #--------------------------------------------------------------------------
  def equippable?(item)
    # If weapon
    if item.is_a?(RPG::Weapon)
      # If included among equippable weapons in current class
      if $data_classes[@class_id].weapon_set.include?(item.id)
        return true
      end
    end
    # If armor
    if item.is_a?(RPG::Armor)
      # If included among equippable armor in current class
      if $data_classes[@class_id].armor_set.include?(item.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Change EXP
  #     exp : new EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [[exp, 9999999].min, 0].max
    # Level up
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      # Learn skill
      for j in $data_classes[@class_id].learnings
        if j.level == @level
          learn_skill(j.skill_id)
        end
      end
    end
    # Level down
    while @exp < @exp_list[@level]
      @level -= 1
    end
    # Correction if exceeding current max HP and max SP
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Change Level
  #     level : new level
  #--------------------------------------------------------------------------
  def level=(level)
    # Check up and down limits
    level = [[level, $data_actors[@actor_id].final_level].min, 1].max
    # Change EXP
    self.exp = @exp_list[level]
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    if skill_id > 0 and not skill_learn?(skill_id)
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # * Forget Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_learn?(skill_id)
    return @skills.include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill can be Used
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if not skill_learn?(skill_id)
      return false
    end
    return super
  end
  #--------------------------------------------------------------------------
  # * Change Name
  #     name : new name
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # * Change Class ID
  #     class_id : new class ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      # Remove items that are no longer equippable
      unless equippable?($data_weapons[@weapon_id])
        equip(0, 0)
      end
      unless equippable?($data_armors[@armor1_id])
        equip(1, 0)
      end
      unless equippable?($data_armors[@armor2_id])
        equip(2, 0)
      end
      unless equippable?($data_armors[@armor3_id])
        equip(3, 0)
      end
      unless equippable?($data_armors[@armor4_id])
        equip(4, 0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change Graphics
  #     character_name : new character file name
  #     character_hue  : new character hue
  #     battler_name   : new battler file name
  #     battler_hue    : new battler hue
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_hue, battler_name, battler_hue)
    @character_name = character_name
    @character_hue = character_hue
    @battler_name = battler_name
    @battler_hue = battler_hue
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    # Return after calculating x-coordinate by order of members in party
    if self.index != nil
      return self.index * 160 + 80
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    return 464
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Z-Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    # Return after calculating z-coordinate by order of members in party
    if self.index != nil
      return 4 - self.index
    else
      return 0
    end
  end
end
