module RPG
  # Data class for the Event command.
  class EventCommand
    def initialize(code = 0, indent = 0, parameters = [])
      @code = code
      @indent = indent
      @parameters = parameters
    end
    
    # The event code.
    attr_accessor :code
    
    # The event code.
    attr_accessor :indent
    
    # Array containing the Move command arguments.
    # The contents vary for each command.
    attr_accessor :parameters
  end
end