# This executes the scripts without displaying any graphics


# Add the lib folder to the load path
dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, "..", "lib")
Dir.chdir(dir)

# Load all parts of the basic library
libs = (Dir[File.join(dir, '..', "lib", "*.rb")] + Dir[File.join(dir, '..', "lib", "rpg", "*.rb")]).sort
libs.each {|lib| require lib}

stub = Object.new
def stub.surface=(s)
  # no-op
end
Graphics.window = stub


#set_trace_func proc { |event, file, line, id, binding, classname| printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname }

Input::set_triggered(Input::C, true)


# Load all game scripts
load File.join(dir, 'script_loader.rb')
