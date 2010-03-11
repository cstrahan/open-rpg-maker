module RPG
  class MoveCommand
    attr_accessor :code
    attr_accessor :parameters

    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
  end
end