script_dir = File.join(File.dirname(__FILE__), "scripts")
scripts = Dir.glob(File.join(script_dir, "*.rb"))
scripts.each do |script|
  load File.expand_path(script)
end