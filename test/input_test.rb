require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/input'

class InputTest < Test::Unit::TestCase
  should "define correct constants" do
    assert Input::A == 11
    assert Input::B == 12
    assert Input::C == 13
    assert Input::X == 14
    assert Input::Y == 15
    assert Input::Z == 16
    assert Input::L == 17
    assert Input::R == 18

    assert Input::SHIFT == 21
    assert Input::CTRL  == 22
    assert Input::ALT   == 23

    assert Input::F5 == 25
    assert Input::F6 == 26
    assert Input::F7 == 27
    assert Input::F8 == 28
    assert Input::F9 == 29
  end
end