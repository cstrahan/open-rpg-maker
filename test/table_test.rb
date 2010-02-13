require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'lib/table'

class TableTest < Test::Unit::TestCase

  def assert_size(table, x=1, y=1, z=1)
    assert table.xsize == x
    assert table.ysize == y
    assert table.zsize == z
  end

  context "A table" do
    
    should "support one to three dimensions" do
      Table.new(0)
      Table.new(1)
      
      Table.new(0,0)
      Table.new(1,2)
      
      Table.new(0,0,0)
      Table.new(1,2,3)
    end
    
    should "report correct nsize" do
      table = Table.new(10)
      assert_size table, 10

      table = Table.new(0)
      assert_size table, 0
      
      table = Table.new(5,10)
      assert_size table, 5, 10
      
      table = Table.new(10,20,30)
      assert_size table, 10, 20, 30
    end
    
    should "be resizable" do
      table = Table.new(0)
      table.resize(10)
      assert_size table, 10
      
      table = Table.new(10,5)
      table.resize(5,10)
      assert_size table, 5, 10
      
      table = Table.new(5,10,15)
      table.resize(15,10,5)
      assert_size table, 15, 10, 5
    end
    
  end
end