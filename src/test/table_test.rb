require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/table.rb'

class TableTest < Test::Unit::TestCase
  context "A table" do
    should "support one to three dimensions" do
      Table.new(0)
      Table.new(1)
      
      Table.new(0,0)
      Table.new(1,2)
      
      Table.new(0,0,0)
      Table.new(1,2,3)
    end
    
    should "should report correct nsize" do
      table = Table.new(10)
      assert table.xsize == 10

      table = Table.new(0)
      assert table.xsize == 0
      assert table.ysize == 1
      assert table.zsize == 1
      
      table = Table.new(5,10)
      assert table.xsize == 5
      assert table.ysize == 10
      assert table.zsize == 1
      
      table = Table.new(10,20,30)
      assert table.xsize == 10
      assert table.ysize == 20
      assert table.zsize == 30
    end
  end
end