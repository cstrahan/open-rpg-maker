module RPG
  class AudioFile
    # The sound file name.
    attr_accessor :name
    
    # The sound's volume (0..100).
    # The default values are 100 for BGM and ME and 80 for BGS and SE.
    attr_accessor :volume
    
    # The sound's pitch (50..150). The default value is 100.
    attr_accessor :pitch
    
    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end
  end
end