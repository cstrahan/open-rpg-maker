require 'yaml'

module Kernel
  def load_data(path)
    File.open(path, 'rb') do |f|
      YAML.load(f)
    end
  end
end