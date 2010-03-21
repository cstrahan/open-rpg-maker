# The module that carries out music and sound processing.
module Audio
  # Starts BGM playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.bgm_play(filename, volume = 100, pitch = 100)
    warn "need to implement Audio.bgm_play"
  end

  # Stops BGM playback.
  def Audio.bgm_stop
    warn "need to implement Audio.bgm_stop"
  end

  # Starts BGM fadeout. time is the length of the fadeout in milliseconds.
  def Audio.bgm_fade(time)
    warn "need to implement Audio.bgm_fade"
  end

  # Starts BGS playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.bgs_play(filename, volume = 100, pitch = 100)
    warn "need to implement Audio.bgs_play"
  end

  # Stops BGS playback.
  def Audio.bgs_stop
    warn "need to implement Audio.bgs_stop"
  end

  # Starts BGS fadeout. time is the length of the fadeout in milliseconds.
  def Audio.bgs_fade(time)
    warn "need to implement Audio.bgs_fade"
  end

  # Starts ME playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  def Audio.me_play(filename, volume = 100, pitch = 100)
    warn "need to implement Audio.me_play"
  end

  # Stops ME playback.
  def Audio.me_stop
    warn "need to implement Audio.me_stop"
  end

  # Starts ME fadeout. time is the length of the fadeout in milliseconds.
  def Audio.me_fade(time)
    warn "need to implement Audio.me_fade"
  end

  # Starts SE playback. Sets the file name, volume, and pitch in turn.
  #
  # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
  #
  # When attempting to play the same SE more than once in a very short period, they will  automatically be filtered to prevent choppy playback.
  def Audio.se_play(filename, volume = 100, pitch = 100)
    warn "need to implement Audio.se_play"
  end

  # Stops SE playback.
  def Audio.se_stop
    warn "need to implement Audio.se_stop"
  end
end
