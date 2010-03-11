module RPG
  # Data class for the Move command.
  class MoveCommand
    # Move command code.
    attr_accessor :code
    
    # Array containing the Move command arguments.
    # The contents vary for each command.
    attr_accessor :parameters

    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
  end
end