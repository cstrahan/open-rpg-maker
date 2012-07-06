require 'zlib'

USE_SCRIPTS_DIR = false


if !USE_SCRIPTS_DIR

  database = File.open('Data/Scripts.rxdata', 'rb') { |f| Marshal.load f }

  database.each do |script|
    script_name = script[1]
    script = Zlib::Inflate.inflate(script[2])
    eval(script, binding, script_name)
  end

else

  script_dir = File.join(File.dirname(__FILE__), "scripts")
  scripts = Dir.glob(File.join(script_dir, "*.rb"))
  scripts.each do |script|
    require File.expand_path(script)
  end

end
