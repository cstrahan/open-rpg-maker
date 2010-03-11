require 'event_command'

# Data class for common events.
module RPG
  class CommonEvent
    def initialize
      @id = 0
      @name = ""
      @trigger = 0
      @switch_id = 1
      @list = [RPG::EventCommand.new]
    end
    
    # The event ID.
    attr_accessor :id
    
    # The event name.
    attr_accessor :name
    
    # The event trigger:
    # 0::    none
    # 1::    autorun
    # 2::    parallel
    attr_accessor :trigger
    
    # The condition switch ID.
    attr_accessor :switch_id
    
    # List of event commands. An {RPG::EventCommand} array.
    # @returns Array<RPG::EventCommand>
    attr_accessor :list
  end
end