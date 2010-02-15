require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/color'

class ColorTest < Test::Unit::TestCase
  context "An instantiated color" do
    should "have attributes set" do
      color = Color.new(10,20,30,40)
      
      assert color.red   == 10
      assert color.green == 20
      assert color.blue  == 30
      assert color.alpha == 40
    end
    
    should "have alpha default to 255" do
      color = Color.new(10,20,30)
      assert color.alpha == 255
    end
    
    should "constrain color channels to 0..255" do
      color = Color.new(-25,999,-9, 256)
      
      assert color.red   == 0
      assert color.green == 255
      assert color.blue  == 0
      assert color.alpha == 255
    end
    
    should "be settable via Color#set" do
      color = Color.new(10,20,30,40)
      color.set 40, 30, 20, 10
      
      assert color.red   == 40
      assert color.green == 30
      assert color.blue  == 20
      assert color.alpha == 10
    end
    
    should "be settable via attributes" do
      color = Color.new(0,0,0,0)
      
      color.red   = 40
      color.green = 30
      color.blue  = 20
      color.alpha = 10
      
      assert color.red   == 40
      assert color.green == 30
      assert color.blue  == 20
      assert color.alpha == 10
    end          
  end
end