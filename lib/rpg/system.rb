require 'rpg/audio_file'

module RPG
  # Data class for the system.
  class System
    def initialize
      @magic_number = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @windowskin_name = ""
      @title_name = ""
      @gameover_name = ""
      @battle_transition = ""
      @title_bgm = RPG::AudioFile.new
      @battle_bgm = RPG::AudioFile.new
      @battle_end_me = RPG::AudioFile.new
      @gameover_me = RPG::AudioFile.new
      @cursor_se = RPG::AudioFile.new("", 80)
      @decision_se = RPG::AudioFile.new("", 80)
      @cancel_se = RPG::AudioFile.new("", 80)
      @buzzer_se = RPG::AudioFile.new("", 80)
      @equip_se = RPG::AudioFile.new("", 80)
      @shop_se = RPG::AudioFile.new("", 80)
      @save_se = RPG::AudioFile.new("", 80)
      @load_se = RPG::AudioFile.new("", 80)
      @battle_start_se = RPG::AudioFile.new("", 80)
      @escape_se = RPG::AudioFile.new("", 80)
      @actor_collapse_se = RPG::AudioFile.new("", 80)
      @enemy_collapse_se = RPG::AudioFile.new("", 80)
      @words = RPG::System::Words.new
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @battleback_name = ""
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    # Magic number used for update checks.
    # Updates changed values every time data is saved in RPGXP.
    attr_accessor :magic_number

    # The initial party. An array of actor IDs.
    attr_accessor :party_members

    # Element list. Text array using element IDs as subscripts, with the
    # element in the 0 position being nil.
    attr_accessor :elements

    # Switch list. Text array using switch IDs as subscripts, with the element
    # in the 0 position being nil.
    attr_accessor :switches

    # Variable list. Text array using variable IDs as subscripts, with the
    # element in the 0 position being nil.
    attr_accessor :variables

    # The window skin (or "windowskin") graphic file name.
    attr_accessor :windowskin_name

    # The title graphic file name.
    attr_accessor :title_name

    # The "Game Over" graphic file name.
    attr_accessor :gameover_name

    # The file name of the transition graphic, displayed when entering battle.
    attr_accessor :battle_transition

    # The title BGM ({RPG::AudioFile}).
    attr_accessor :title_bgm

    # The battle BGM ({RPG::AudioFile}).
    attr_accessor :battle_bgm

    # The battle end ME ({RPG::AudioFile}).
    attr_accessor :battle_end_me

    # The gameover ME ({RPG::AudioFile}).
    attr_accessor :gameover_me

    # The cursor SE ({RPG::AudioFile}).
    attr_accessor :cursor_se

    # The decision SE ({RPG::AudioFile}).
    attr_accessor :decision_se

    # The cancel SE ({RPG::AudioFile}).
    attr_accessor :cancel_se

    # The buzzer SE ({RPG::AudioFile}).
    attr_accessor :buzzer_se

    # The equip SE ({RPG::AudioFile}).
    attr_accessor :equip_se

    # The shop SE ({RPG::AudioFile}).
    attr_accessor :shop_se

    # The save SE ({RPG::AudioFile}).
    attr_accessor :save_se

    # The load SE ({RPG::AudioFile}).
    attr_accessor :load_se

    # The battle start SE ({RPG::AudioFile}).
    attr_accessor :battle_start_se

    # The escape SE ({RPG::AudioFile}).
    attr_accessor :escape_se

    # The actor collapse SE ({RPG::AudioFile}).
    attr_accessor :actor_collapse_se

    # The enemy collapse SE ({RPG::AudioFile}).
    attr_accessor :enemy_collapse_se

    # Terms ({RPG::System::Words}).
    attr_accessor :words

    # Party settings for battle tests. An {RPG::System::TestBattler} array.
    # @return [Array<RPG::System::TestBattler>]
    attr_accessor :test_battlers

    # The troop ID for battle tests.
    attr_accessor :test_troop_id

    # The map ID of the player's initial position.
    attr_accessor :start_map_id

    # The map X-coordinate of the player's initial position.
    attr_accessor :start_x

    # The map Y-coordinate of the player's initial position.
    attr_accessor :start_y

    # The battle background graphic file name, for battle tests and internal use.
    attr_accessor :battleback_name

    # The battler graphic file name, for internal use.
    attr_accessor :battler_name

    # The adjustment value for the battler graphic's hue (0..360),
    # for internal use.
    attr_accessor :battler_hue

    # The ID of the map currently being edited, for internal use.
    attr_accessor :edit_map_id

    # Data class for terminology.
    class Words
      def initialize
        @gold = ""
        @hp = ""
        @sp = ""
        @str = ""
        @dex = ""
        @agi = ""
        @int = ""
        @atk = ""
        @pdef = ""
        @mdef = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
      end

      # The term "G" (the unit of currency).
      attr_accessor :gold

      # The term "HP" (hit points).
      attr_accessor :hp

      # The term "SP" (skill points).
      attr_accessor :sp

      # The term "Strength".
      attr_accessor :str

      # The term "Dexterity".
      attr_accessor :dex

      # The term "Agility".
      attr_accessor :agi

      # The term "Intelligence".
      attr_accessor :int

      # The term "Attack Power".
      attr_accessor :atk

      # The term "Physical Defense".
      attr_accessor :pdef

      # The term "Magic Defense".
      attr_accessor :mdef

      # The term "Weapon".
      attr_accessor :weapon

      # The term "Shield".
      attr_accessor :armor1

      # The term "Helmet".
      attr_accessor :armor2

      # The term "Body armor".
      attr_accessor :armor3

      # The term "Accessory".
      attr_accessor :armor4

      # The term "Attack".
      attr_accessor :attack

      # The term "Skill".
      attr_accessor :skill

      # The term "Defense".
      attr_accessor :guard

      # The term "Item".
      attr_accessor :item

      # The term "Equip".
      attr_accessor :equip
    end

    # Data class for the battlers used in battle tests.
    class TestBattler
      def initialize
        @actor_id = 1
        @level = 1
        @weapon_id = 0
        @armor1_id = 0
        @armor2_id = 0
        @armor3_id = 0
        @armor4_id = 0
      end

      # The actor ID.
      attr_accessor :actor_id

      # The actor's level.
      attr_accessor :level

      # The actor's weapon ID.
      attr_accessor :weapon_id

      # The actor's shield ID.
      attr_accessor :armor1_id

      # The actor's helmet ID.
      attr_accessor :armor2_id

      # The actor's body armor ID.
      attr_accessor :armor3_id

      # The actor's accessory ID.
      attr_accessor :armor4_id
    end
  end
end
