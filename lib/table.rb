class Table
  attr_reader :xsize, :ysize, :zsize
  
  def initialize(xsize, ysize=nil, zsize=nil)
    raise "invalid params - expected (xsize[, ysize[, zsize]])" unless params_valid?(xsize, ysize, zsize)
    
    @dimensions = dimensions(xsize, ysize, zsize)
    @items = []
    
    resize(xsize, ysize, zsize)
  end

  def resize(xsize, ysize=nil, zsize=nil)
    raise "invalid params - expected (xsize[, ysize[, zsize]])" unless params_valid?(xsize, ysize, zsize)
    raise "wrong # of sizes" if dimensions(xsize, ysize, zsize) != @dimensions

    # Set and coerce the nsize variables
    @xsize, @ysize, @zsize = xsize || 1, ysize || 1, zsize || 1
  end
  
  def [](x, y=nil, z=nil)
    raise unless params_valid?(x, y, z)
    raise "wrong # of indecies" if dimensions(x, y, z) != @dimensions
    
    return nil unless (0..@xsize).include? (x or 0) and
                      (0..@ysize).include? (y or 0) and
                      (0..@zsize).include? (z or 0)
    
    case @dimensions
    when 1
      return @items[x]
    when 2
      return @items.fetch(x){ [] }[y]
    when 3
      return @items.fetch(x){ [] }.fetch(y){ [] }[z]
    end
  end
  
  def []=(*args)
    raise "wrong # of indecies" if not args.size == (@dimensions + 1)
    x, y, z = args.first(@dimensions)
    raise if not params_valid?(x, y, z)
    raise "wrong # of indecies" if dimensions(x, y, z) != @dimensions  
    
    item = args[-1]
    
    case @dimensions
    when 1
      @items[x] = item
    when 2
      @items.fetch(x){ @items[x]=[] }[y] = item
    when 3
      @items.fetch(x){ @items[x]=[] }.fetch(y){ @items[x][y]=[] }[z] = item
    end
  end

private
  
  def params_valid?(x, y, z)
    return !x.nil? && !(y.nil? && !z.nil?)
  end
  
  def dimensions(x, y, z)
    return (x == nil ? 0 : 1) +
           (y == nil ? 0 : 1) +
           (z == nil ? 0 : 1)
  end

end