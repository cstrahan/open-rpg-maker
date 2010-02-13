require 'Color.rb'

# TODO: Need to support an array of font names
#       ... should Font#name return the first available font,
#       or should it return the array?
class Font
  attr_accessor :name
  attr_accessor :size
  attr_accessor :bold
  attr_accessor :italic
  attr_accessor :color
  
  def initialize(name=nil, size=nil)
    @name = name || Font.default_name
    @size = size || Font.default_size
    @bold = Font.default_bold
    @italic = Font.default_italic
    @color = Font.default_color
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