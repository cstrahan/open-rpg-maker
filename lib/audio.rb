# The module that carries out music and sound processing.
module Audio
  # Starts BGM playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.bgm_play(filename, volume = 100, pitch = 100)
    raise "not implemented"
  end

  # Stops BGM playback.
  def Audio.bgm_stop
    raise "not implemented"
  end

  # Starts BGM fadeout. time is the length of the fadeout in milliseconds.
  def Audio.bgm_fade(time)
    raise "not implemented"
  end

  # Starts BGS playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.bgs_play(filename, volume = 100, pitch = 100)
    raise "not implemented"
  end

  # Stops BGS playback.
  def Audio.bgs_stop
    raise "not implemented"
  end

  # Starts BGS fadeout. time is the length of the fadeout in milliseconds.
  def Audio.bgs_fade(time)
    raise "not implemented"
  end

  # Starts ME playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.me_play(filename, volume = 100, pitch = 100)
    raise "not implemented"
  end

  # Stops ME playback.
  def Audio.me_stop
    raise "not implemented"
  end

  # Starts ME fadeout. time is the length of the fadeout in milliseconds.
  def Audio.me_fade(time)
    raise "not implemented"
  end

  # Starts SE playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  #
  # When attempting to play the same SE more than once in a very short period, they will  automatically be filtered to prevent choppy playback.
  def Audio.se_play(filename, volume = 100, pitch = 100)
    raise "not implemented"
  end

  # Stops SE playback.
  def Audio.se_stop
    raise "not implemented"
  end
end
