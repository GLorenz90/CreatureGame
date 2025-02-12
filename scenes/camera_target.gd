extends Node2D

@export var SPEED := 4.0;
var target: CharacterBody2D = null;
var cam_height := 1080.0;

func _ready():
  Signals.character_set.connect(_on_character_set);
  
  $Curtain.show();
  cam_height = -get_viewport_rect().size.y;
  
  if(get_tree().paused):
    $Curtain.position.y = 0;
  else:
    $Curtain.position.y = cam_height - 190;
# end _ready

func _process(delta):
  cam_height = -get_viewport_rect().size.y;
  
  if(Input.is_action_just_pressed("global_pause")) && target != null:
    get_tree().paused = !get_tree().paused;
    # Add in creating the menu and 
  #end if
  
  if(get_tree().paused):
    # Move Curtain
    $Curtain.position.y = lerpf($Curtain.position.y, 0, delta * 10);
  else:
    # Move Curtain
    $Curtain.position.y = lerpf($Curtain.position.y, cam_height - 190, delta * 10);
  
    # Move Camera
    if(target):
      global_position.x = lerpf(position.x, target.global_position.x, delta * SPEED/2);
      global_position.y = lerpf(position.y, target.global_position.y, delta * SPEED);
    # end if
    
    # Change Character
    checkForChange();
  # end if
# end _process

func _on_character_set(newChar: PlayerCharacter):
  print("_on_character_set");
  target = newChar;
# end _on_character_set

#TODO: move to character manager
func checkForChange():
  if(Input.is_action_just_pressed("change_character")):
    var newCharacter = Global.get_next_character();
    var oldCharacter = target; # This is the Body of the character
    var oldCharacterParent = oldCharacter.get_parent(); # This is the root node of the character
    var currentScene = Global.main.sceneParent.get_child(0);
    currentScene.add_child(newCharacter);
    
    # Copy important state
    newCharacter.global_position.x = oldCharacter.global_position.x;
    newCharacter.global_position.y = oldCharacter.global_position.y;
    
    var newSprite = newCharacter.find_child("Sprite");
    var oldSprite = oldCharacter.find_child("Sprite");
    if(newSprite && oldSprite): newSprite.scale.x = oldSprite.scale.x;
    
    var newDash = newCharacter.find_child("Dash");
    var oldDash = oldCharacter.find_child("Dash");
    if(newDash && oldDash): newDash.scale.x = oldDash.scale.x;
    
    # Remove old character
    currentScene.remove_child(oldCharacterParent);
    oldCharacterParent.queue_free();
  #end if
#end checkForChange
