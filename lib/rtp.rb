module RTP
  # Cache the standard RTP path
  common_path = System::Environment.get_folder_path(System::Environment::SpecialFolder.common_program_files)
  
  if (!common_path.nil? && !common_path.empty?)
    STANDARD_PATH = File.join(common_path, 'Enterbrain/RGSS/Standard/')
  else
    STANDARD_PATH = nil
  end

  # Finds a file path given a RTP file name.
  #   RTP.locate('Graphics/Tilesets/001-Grassland01')
  #   #=> 'C:/Program Files/Common Files/Enterbrain/RGSS/Standard/Graphics/Tilesets/001-Grassland01.png'
  def self.locate(path)
    # See if the file is relative to the game folder (Dir.pwd)
    located_path = nil
    located_path = locate_first(path)
    
    # If we didn't find any file, lets try looking in the the standard RTP
    if located_path.nil? and !full_path?(path)
      if !STANDARD_PATH.nil?
        rtp_relative_path = File.join(STANDARD_PATH, path)
        located_path = locate_first(rtp_relative_path)
      end
    end
    
    return located_path
  end

private

  # Returns the first file that matches the path; returns nil otherwise.
  # Assumes an extension of '.*' if one is not present.
  def self.locate_first(path)
    located_path = path
    located_path = located_path + ".*" if !has_extension?(located_path)
    located_path = located_path.gsub('\\', '/') # make Dir.glob happy
    located_path = Dir.glob(located_path)[0]    # naively pick first one
  end
  
  def self.has_extension?(path)
    File.basename(path) != File.basename(path, '.*')
  end
  
  def self.full_path?(path)
    path == File.expand_path(path)
  end
  
end