=begin
s = Sprite.new
s.bitmap = Bitmap.new 640, 480
while true
  Graphics.update
  Input.update
  s.bitmap.clear
  s.bitmap.draw_text(Rect.new(0,0,300,25), "press?#{Input.press?(Input::C)}")
  s.bitmap.draw_text(Rect.new(0,25,300,25), "trigger?#{Input.trigger?(Input::C)}")
  s.bitmap.draw_text(Rect.new(0,50,300,25), "repeat?#{Input.repeat?(Input::C)}")
end
=end

Input.set_triggered(Input::C, true)

#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  After defining each class, actual processing begins here.
#==============================================================================

begin
  # Prepare for transition
  Graphics.freeze
  # Make scene object (title screen)
  $scene = Scene_Title.new
  # Call main method as long as $scene is effective
  while $scene != nil
    $scene.main
  end
  # Fade out
  Graphics.transition(20)
rescue Errno::ENOENT
  # Supplement Errno::ENOENT exception
  # If unable to open file, display message and end
  filename = $!.message.sub("No such file or directory - ", "")
  print("Unable to find file #{filename}.")
end
