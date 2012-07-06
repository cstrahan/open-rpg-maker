require 'System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Windows.Forms'
require 'System.Drawing'
require 'singleton'

# The main form
class MainForm < System::Windows::Forms::Form
  include Singleton
  include System::Windows::Forms

  def initialize

    self.auto_size_mode = AutoSizeMode.grow_and_shrink
    self.auto_size = true
    self.text = "Open RPG Maker"

    @canvas = PictureBox.new
    @canvas.width = 640
    @canvas.height = 480
    @canvas.size_mode = PictureBoxSizeMode.normal
    @canvas.margin = Padding.empty
    @canvas.back_color = System::Drawing::Color.black
    # @canvas.background_image = scene
    self.controls.add(@canvas)

    self.load do |sender, e|
      Object.instance_eval do
      end
    end


    key_map = { Keys.space  => Input::C,      Keys.enter    => Input::C,
                Keys.escape => Input::B,      Keys.num_pad0 => Input::B,
                Keys.shift  => Input::A,      Keys.z        => Input::A,
                Keys.x      => Input::B,      Keys.c        => Input::C,
                Keys.a      => Input::X,      Keys.s        => Input::Y,
                Keys.d      => Input::Z,      Keys.q        => Input::L,
                Keys.w      => Input::R,      Keys.enter    => Input::C,
                Keys.down   => Input::DOWN,   Keys.left     => Input::LEFT,
                Keys.right  => Input::RIGHT,  Keys.up       => Input::UP }

    dir_inputs = [ Input::DOWN, Input::LEFT, Input::RIGHT, Input::UP ]
      #Input.set_dir4(key_map[e.key_code]) if dir_map[e.key_code]

    self.key_down do |sender, e|
      Input.set_pressed(key_map[e.key_code], true)
      Input.set_triggered(key_map[e.key_code], true)
      Input.set_repeated(key_map[e.key_code], true)

      Input.set_dir4(key_map[e.key_code]) if dir_inputs.include? key_map[e.key_code]
    end

    self.key_up do |sender, e|
      Input.set_pressed(key_map[e.key_code], false)
      Input.set_triggered(key_map[e.key_code], false)
      Input.set_repeated(key_map[e.key_code], false)

      Input.set_dir4(key_map[0]) if dir_inputs.include? key_map[e.key_code]
    end

  end

  def surface=(bmp)
    @canvas.background_image = bmp
  end
end


# Add the lib folder to the load path
dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, "..", "lib")

# Load all parts of the basic library
libs = (Dir[File.join(dir, '..', "lib", "*.rb")] + Dir[File.join(dir, '..', "lib", "rpg", "*.rb")]).sort
puts libs
libs.each {|lib| require lib}

# Use this window for the display
Graphics.window = MainForm.instance

# Load all game scripts (start the game loop)
Thread.new do
  Dir.chdir(dir)
  require File.join(dir, 'script_loader.rb')
end

# Get irb running
Thread.new do
  require 'rubygems'
  require 'irb'
  module IRB # :nodoc:
    def self.start_session(binding)
      unless @__initialized
        args = ARGV
        ARGV.replace(ARGV.dup)
        IRB.setup(nil)
        ARGV.replace(args)
        @__initialized = true
      end

      workspace = WorkSpace.new(binding)

      irb = Irb.new(workspace)

      @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
      @CONF[:MAIN_CONTEXT] = irb.context

      catch(:IRB_EXIT) do
        irb.eval_input
      end
    end
  end
  IRB.start_session(binding)
end

# Run
System::Windows::Forms::Application.run(MainForm.instance)
