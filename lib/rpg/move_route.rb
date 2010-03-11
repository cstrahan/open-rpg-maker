require 'move_command'

module RPG
  # Data class for the move route (movement route).
  class MoveRoute
    def initialize
      @repeat = true
      @skippable = false
      @list = [RPG::MoveCommand.new]
    end
    
    # Truth value of the [Repeat Action] option.
    attr_accessor :repeat
    
    # Truth value of the [Ignore if Can't Move] option.
    attr_accessor :skippable
    
    # Program contents. An {RPG::MoveCommand} array.
    # @returns[Array<RPG::MoveCommand>]
    attr_accessor :list
  end
end