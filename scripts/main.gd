extends Node2D
class_name Main

var music: AudioStreamPlayer;
var clickSound: AudioStreamPlayer;
var sceneParent: Node2D;

func _init():
  Global.main = self;
# end _init

func _ready():
  music = $Globals/Music;
  sceneParent = $SceneParent;
  clickSound = $Globals/ClickSound;
# end _ready

func _on_audio_stream_player_finished():
  music.play();
# end _on_audio_stream_player_finished

#region FUNCTIONS ========================================================================================
func changeScene(sceneKey: Global.SCENE_KEYS):
  get_tree().paused = true;
  var activeScene = sceneParent.get_child(0);
  
  var newScene = Global.SCENES.get(sceneKey).instantiate();
  sceneParent.add_child(newScene);
  
  sceneParent.remove_child(activeScene);
  activeScene.queue_free();
  get_tree().paused = false;
#endregion
