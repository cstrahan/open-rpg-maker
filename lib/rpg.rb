dir = File.dirname(__FILE__)
Dir[File.join(dir, "rpg", "*.rb")].each {|lib| require lib}