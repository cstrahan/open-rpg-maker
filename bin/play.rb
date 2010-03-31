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

    
    key_map = { Keys::space  => Input::C, Keys::enter    => Input::C,
                Keys::escape => Input::B, Keys::num_pad0 => Input::B,
                Keys::shift  => Input::A, Keys::z        => Input::A,
                Keys::x      => Input::B, Keys::c        => Input::C,
                Keys::a      => Input::X, Keys::s        => Input::Y,
                Keys::d      => Input::Z, Keys::q        => Input::L,
                Keys::w      => Input::R, Keys::enter    => Input::C }

    self.key_down do |sender, e|
      Input.set_pressed(key_map[e.key_code], true)
      Input.set_triggered(key_map[e.key_code], true)
      Input.set_repeated(key_map[e.key_code], true)
    end

    self.key_up do |sender, e|
      Input.set_pressed(key_map[e.key_code], false)
      Input.set_triggered(key_map[e.key_code], false)
      Input.set_repeated(key_map[e.key_code], false)
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

# Run
System::Windows::Forms::Application.run(MainForm.instance)
