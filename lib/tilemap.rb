class Tilemap
  attr_accessor :tileset
  attr_accessor :autotiles
  attr_accessor :map_data
  attr_accessor :flash_data
  attr_accessor :priorities
  attr_accessor :visible
  attr_accessor :ox
  attr_accessor :oy

  def initialize(viewport = nil)
    raise "not implemented"
    
    @viewport = viewport
    
  end

  def disposed()
    raise "not implemented"
    
    @disposed = true
  end

  def disposed?()
    @disposed
  end
end