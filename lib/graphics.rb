module Graphics
  class << self
    attr_accessor :frame_rate, :frame_count
  end

  def self.update()
    raise "not implemented"
  end

  def self.freeze()
    raise "not implemented"
  end

  def self.transition(duration = 8, filename = nil, vague = 40)
    raise "not implemented"
  end

  def self.frame_reset()
    raise "not implemented"
  end
end