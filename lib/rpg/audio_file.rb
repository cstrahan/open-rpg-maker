module RPG
  class AudioFile
    attr_accessor :name, :volume, :pitch
    
    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end
  end
end