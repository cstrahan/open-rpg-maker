require 'table'

module RPG
  class Class
    attr_accessor :id,          :name,      :position,
                  :weapon_set,  :armor_set, :element_ranks,
                  :state_ranks, :learnings

    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
    end

    
    class Learning
      attr_accessor :level, :skill_id

      def initialize
        @level = 1
        @skill_id = 1
      end
    end
  end
end