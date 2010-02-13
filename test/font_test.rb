require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/font'

class FontTest < Test::Unit::TestCase
  should "honor defaults when instantiated" do
    font = Font.new
    
    assert font.name   == Font.default_name
    assert font.size   == Font.default_size
    assert font.bold   == Font.default_bold
    assert font.italic == Font.default_italic
    assert font.color  == Font.default_color
  end
  
  should "execute exist? without error" do
    Font.exist? "MS PGothic"
  end
end