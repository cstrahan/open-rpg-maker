# TODO: Need to support an array of font names
#       ... should Font#name return the first available font,
#       or should it return the array?
class Font
  attr_accessor :name
  attr_accessor :size
  attr_accessor :bold
  attr_accessor :italic
  attr_accessor :color
  
  def initialize(name, size)
    @name = name || Font.default_name
    @size = size || Font.default_size
    @bold = Font.default_name
    @italic = Font.default_size
    @color = Font.default_name
    @size = Font.default_size
  end
  
  def self.exist?(name)
    raise "not implemented"
  end
  
  # Defaults
  @default_name = "MS PGothic"
  @default_size = 22
  @default_bold = false
  @default_italic = false
  @default_color = Color.new(255,255,255,255)
  
  class << self
    attr_accessor :default_name
    attr_accessor :default_size
    attr_accessor :default_bold
    attr_accessor :default_italic
    attr_accessor :default_color
  end
end