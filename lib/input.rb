# A module that handles input data from a gamepad or keyboard.
module Input
  # Updates input data. As a rule, this method is called once per frame.
  def self.update()
    raise "not implemented"
  end

  # Determines whether the button num is currently being pressed.
  #
  # If the button is being pressed, returns TRUE. If not, returns FALSE.
  #
  # @example Example
  # if Input.press?(Input::C)
  #   do_something
  # end
  def self.press?(num)
    raise "not implemented"
  end

  # Determines whether the button num is being pressed again.
  #
  # "Pressed again" is seen as time having passed between the button being
  # not pressed and being pressed.
  #
  # If the button is being pressed, returns TRUE. If not, returns FALSE.
  def self.trigger?(num)
    raise "not implemented"
  end

  # Determines whether the button num is being pressed again.
  #
  # Unlike trigger?, takes into account the repeat input of a button
  # being held down continuously.
  #
  # If the button is being pressed, returns TRUE. If not, returns FALSE.
  def self.repeat?(num)
    raise "not implemented"
  end

  # Checks the status of the directional buttons, translates the data
  # into a specialized 4-direction input format, and returns the number
  # pad equivalent (2, 4, 6, 8).
  # 
  # If no directional buttons are being pressed (or the equivalent), returns 0.
  def self.dir4()
    raise "not implemented"
  end

  # Checks the status of the directional buttons, translates the data into
  # a specialized 8-direction input format, and returns the
  # number pad equivalent (1, 2, 3, 4, 6, 7, 8, 9).
  #
  # If no directional buttons are being pressed (or the equivalent), returns 0.
  def self.dir8()
    raise "not implemented"    
  end

  DOWN  = 2
  LEFT  = 4
  RIGHT = 6
  UP    = 8

  A = 11
  B = 12
  C = 13
  X = 14
  Y = 15
  Z = 16
  L = 17
  R = 18

  SHIFT = 21
  CTRL  = 22
  ALT   = 23

  F5 = 25
  F6 = 26
  F7 = 27
  F8 = 28
  F9 = 29
end