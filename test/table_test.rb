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

    should "set/get correct value" do
      table = Table.new(10)
      table[3] = 23
      table[9] = 45
      assert table[3] == 23
      assert table[9] == 45

      table = Table.new(2,2)
      table[0,1] = 16
      assert table[0,1] == 16

      table = Table.new(10,20,30)
      table[4,1,4] = 15
      assert table[4,1,4] == 15
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

    should "keep values before and after resize" do
      # Create table with xsize of zero, set item `1' to `45'
      table = Table.new(0)
      table[1] = 45

      # `1' is outside the range - should return nil
      assert table[1] == nil

      # resizing should allow us to get the item
      table.resize(1)
      assert table[1] == 45

      # resizing down to `0' and back to `1' should still return the item
      table.resize(0)
      table.resize(1)
      assert table[1] == 45
    end

  end
end