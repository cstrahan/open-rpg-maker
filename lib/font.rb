require 'color'

# TODO: Need to support an array of font names
#       ... should Font#name return the first available font,
#       or should it return the array?
class Font
  attr_accessor :name, :size, :bold, :italic, :color

  # Creates a Font object.
  def initialize(name=nil, size=nil)
    @name = name || Font.default_name
    @size = size || Font.default_size
    @bold = Font.default_bold
    @italic = Font.default_italic
    @color = Font.default_color
  end

  # Returns TRUE when the specified font exists within the system.
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
    attr_accessor :default_name, :default_size, :default_bold, :default_italic, :default_color
  end
end
