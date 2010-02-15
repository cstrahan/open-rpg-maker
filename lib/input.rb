module Input
  def self.update()
    raise "not implemented"
  end

  def self.press?(num)
    raise "not implemented"
  end

  def self.trigger?(num)
    raise "not implemented"
  end

  def self.repeat?(num)
    raise "not implemented"
  end

  def self.dir4()
    raise "not implemented"
  end

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