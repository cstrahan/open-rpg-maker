dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, "..", "lib")
libs = Dir[File.join(dir, '..', "lib", "*.rb")].sort
libs.each {|lib| require lib}
load File.join(dir, 'script_loader.rb')