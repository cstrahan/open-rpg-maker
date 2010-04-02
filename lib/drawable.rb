class Drawable

  @@all = []

  def self.all
    @@all.select { |d| not d.respond_to?(:disposed) && d.disposed }
  end

  def initialize
    @@all << self
  end

  def draw(bmp)
  end
end
