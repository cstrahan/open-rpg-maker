require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/rect'

class RectTest < Test::Unit::TestCase
  context "An instantiated Rect" do
    should "have attributes set" do
      rect = Rect.new(10,20,30,40)
      
      assert rect.x      == 10
      assert rect.y      == 20
      assert rect.width  == 30
      assert rect.height == 40
    end
    
    should "be settable via Rect#set" do
      rect = Rect.new(10,20,30,40)
      rect.set 40, 30, 20, 10
      
      assert rect.x      == 40
      assert rect.y      == 30
      assert rect.width  == 20
      assert rect.height == 10
    end
    
    should "be settable via attributes" do
      rect = Rect.new(0,0,0,0)
      
      rect.x      = 40
      rect.y      = 30
      rect.width  = 20
      rect.height = 10
      
      assert rect.x      == 40
      assert rect.y      == 30
      assert rect.width  == 20
      assert rect.height == 10
    end
  end
end