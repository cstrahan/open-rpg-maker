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
    # @canvas.background_image = scene
    self.controls.add(@canvas)
    
    self.load do |sender, e|
      Object.instance_eval do
      end
    end
  end
  
  def surface=(bmp)
    # This is ugly as hell...
    # Instead of making my own Bitmap class, I should just monkey-path
    # System::Drawing::Bitmap as needed, and include it like so:
    #   Bitmap = System::Drawing::Bitmap
    @canvas.background_image = bmp
  end
end


# Add the lib folder to the load path
dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, "..", "lib")
Dir.chdir(dir)

# Load all parts of the basic library
libs = (Dir[File.join(dir, '..', "lib", "*.rb")] + Dir[File.join(dir, '..', "lib", "rpg", "*.rb")]).sort
libs.each {|lib| require lib}

# Use this window for the display
Graphics.window = MainForm.instance

# Load all game scripts (start the game loop)
Thread.new do
  dir = File.expand_path(File.dirname(__FILE__))
  require File.join(dir, 'script_loader.rb')
end

# Run
System::Windows::Forms::Application.run(MainForm.instance)