class Drawable

  @@all = []

  def self.all
    @@all
  end

  def initialize
    @@all << self
  end

  def draw(bmp)
  end
end
