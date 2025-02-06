extends Node2D

func _on_quit_button_pressed():
  get_tree().quit();
# end _on_quit_button_pressed

func _on_continue_button_pressed():
  Global.main.clickSound.play();
  Global.main.changeScene(Global.SCENE_KEYS.LEVEL_1);
  Global.main.music.play();
# end _on_continue_button_pressed
