# The multidimensional array class. Each element takes up 2 signed bytes, ranging from -32,768 to 32,767.
#
# Ruby's Array class does not run efficiently when handling large amounts of data, hence the inclusion of this class.
class Table
  
  # Gets the x dimension of the array.
  # @return [Integer]
  attr_reader :xsize

  # Gets the y dimension of the array.
  # @return [Integer]
  attr_reader :ysize

  # Gets the z dimension of the array.
  # @return [Integer]
  attr_reader :zsize

  # Change the size of the array. All data from before the size change is retained.
  def initialize(x, y = 0, z = 0)
     @dim = 1 + (y > 0 ? 1 : 0) + (z > 0 ? 1 : 0)
     @xsize, @ysize, @zsize = x, [y, 1].max, [z, 1].max
     @data = Array.new(x * y * z, 0)
  end
  
  # Accesses the array's elements. Pulls the same number of arguments as there
  # are dimensions in the created array. Returns nil if the specified element does not exist.
  def [](x, y = 0, z = 0)
     @data[x + y * @xsize + z * @xsize * @ysize]
  end
  
  def []=(*args)
     x = args[0]
     y = args.size > 2 ? args[1] : 0
     z = args.size > 3 ? args[2] : 0
     v = args.pop
     @data[x + y * @xsize + z * @xsize * @ysize] = v
  end
  
  def _dump(d = 0)
     [@dim, @xsize, @ysize, @zsize, @xsize * @ysize * @zsize].pack('LLLLL') <<
     @data.pack("S#{@xsize * @ysize * @zsize}")
  end
  
  def self._load(s)
     size, nx, ny, nz, items = *s[0, 20].unpack('LLLLL')
     t = Table.new(*[nx, ny, nz][0,size])
     data = s[20, items * 2].unpack("S#{items}")
     t.instance_variable_set("@data", data)
     t
  end
end