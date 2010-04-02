# NOTE: IronRuby 1.0 rc4's YAML has a bug...
#require 'yaml'

module Kernel
  def load_data(path)
    File.open(path, 'rb') do |f|
      Marshal.load(f)
    end
  end
end
