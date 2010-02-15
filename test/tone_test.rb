require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/tone'

class ToneTest < Test::Unit::TestCase
  context "An instantiated Tone" do
    should "have attributes set" do
      tone = Tone.new(10,20,30,40)
      
      assert tone.red   == 10
      assert tone.green == 20
      assert tone.blue  == 30
      assert tone.gray  == 40
    end
    
    should "have gray default to 0" do
      tone = Tone.new(10,20,30)
      assert tone.gray == 0
    end
    
    should "constrain rgb to -255..255 and gray to 0..255" do
      tone = Tone.new(-999,-32,32, 256)
      
      assert tone.red   == -255
      assert tone.green == -32
      assert tone.blue  ==  32
      assert tone.gray  ==  255
    end
    
    should "be settable via Tone#set" do
      tone = Tone.new(10,20,30,40)
      tone.set 40, 30, 20, 10
      
      assert tone.red   == 40
      assert tone.green == 30
      assert tone.blue  == 20
      assert tone.gray  == 10
    end
    
    should "be settable via attributes" do
      tone = Tone.new(0,0,0,0)
      
      tone.red   = 40
      tone.green = 30
      tone.blue  = 20
      tone.gray  = 10
      
      assert tone.red   == 40
      assert tone.green == 30
      assert tone.blue  == 20
      assert tone.gray  == 10
    end
  end
end