module RPG
  class MoveCommand(code = 0, parameters = [])
    def initialize
      @code = code
      @parameters = parameters
    end
    attr_accessor :code
    attr_accessor :parameters
  end
end