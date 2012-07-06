require 'rpg/event_command'

module RPG
  class Troop
    def initialize
      @id = 0
      @name = ""
      @members = []
      @pages = [RPG::BattleEventPage.new] # Shouldn't this be [RPG::Troop::Member.new] ?
    end

    # Troop ID.
    attr_accessor :id

    # Troop name.
    attr_accessor :name

    # Troop members. An {RPG::Troop::Member} array.
    # @returns [Array<RPG::Troop::Member>]
    attr_accessor :members

    # Battle events. An {RPG::Troop::Page} array.
    # @returns [Array<RPG::Troop::Page>]
    attr_accessor :pages

    # Data class for troop members.
    class Member
      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
        @immortal = false
      end

      # The enemy ID.
      attr_accessor :enemy_id

      # The troop member's X-coordinate.
      attr_accessor :x

      # The troop member's Y-coordinate.
      attr_accessor :y

      # Truth value of the [Appear Midway] option.
      attr_accessor :hidden

      # Truth value of the [Immortal] option.
      attr_accessor :immortal
    end

    # Data class for battle events (pages).
    class Page
      def initialize
        @condition = RPG::Troop::Page::Condition.new
        @span = 0
        @list = [RPG::EventCommand.new]
      end

      # Condition ({RPG::Troop::Page::Condition}).
      # @returns [RPG::Troop::Page::Condition]
      attr_accessor :condition

      # Span:
      # 0::    battle
      # 1::    turn
      # 2::    moment
      attr_accessor :span

      # Program contents. An {RPG::EventCommand} array.
      # @returns [Array<RPG::EventCommand>]
      attr_accessor :list

      # A database of battle event [Conditions].
      class Condition
        def initialize
          @turn_valid = false
          @enemy_valid = false
          @actor_valid = false
          @switch_valid = false
          @turn_a = 0
          @turn_b = 0
          @enemy_index = 0
          @enemy_hp = 50
          @actor_id = 1
          @actor_hp = 50
          @switch_id = 1
        end

        # Truth value for whether the [Turn] condition is valid.
        attr_accessor :turn_valid

        # Truth value for whether the [Enemy] condition is valid.
        attr_accessor :enemy_valid

        # Truth value for whether the [Actor] condition is valid.
        attr_accessor :actor_valid

        # Truth value for whether the [Switch] condition is valid.
        attr_accessor :switch_valid

        # a value specified in the [Turn] condition.
        # To be input in the form a + bx.
        attr_accessor :turn_a

        # b value specified in the [Turn] condition.
        # To be input in the form a + bx.
        attr_accessor :turn_b

        # Troop member index specified in the [Enemy] condition (0..7).
        attr_accessor :enemy_index

        # HP percentage specified in the [Enemy] condition.
        attr_accessor :enemy_hp

        # Actor ID specified in the [Actor] condition.
        attr_accessor :actor_id

        # HP percentage specified in the [Actor] condition.
        attr_accessor :actor_hp

        # Switch ID specified in the [Switch] condition.
        attr_accessor :switch_id
      end
    end
  end
end
