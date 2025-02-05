extends Node2D

@export var SPEED = 4;
var target: CharacterBody2D = null;
var target_character: Node2D = null;
var cam_height := 1080.0;

# Called when the node enters the scene tree for the first time.
func _ready():
  $Curtain.show();
  
  cam_height = get_viewport_rect().size.y * -1;
  
  if(get_tree().paused):
    $Curtain.position.y = 0;
  else:
    $Curtain.position.y = cam_height - 10;
    
  if(target == null):
    target_character = get_tree().get_first_node_in_group("player");
    if(target_character != null):
      set_new_target();
    #end if
  #end if
#end _ready()

func set_new_target():
  var target_children = target_character.find_children("*", "CharacterBody2D");
  if(target_children.size() > 0): target = target_children[0];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if(Input.is_action_just_pressed("global_pause")):
    get_tree().paused = !get_tree().paused;
    # Add in creating the menu and 
  #end if
  
  if(get_tree().paused):
    # Move Curtain
    $Curtain.position.y = lerpf($Curtain.position.y, 0, delta * 10);
  else:
    # Move Curtain
    $Curtain.position.y = lerpf($Curtain.position.y, cam_height - 10, delta * 10);
  
    # Move Camera
    if(target):
      position.x = lerpf(position.x, target.global_position.x, delta * SPEED/2);
      position.y = lerpf(position.y, target.global_position.y, delta * SPEED);
    #end if
    
    # Change Character
    check_for_change();
  #end if
#end _process

#TODO: move to character manager
func check_for_change():
  if(Input.is_action_just_pressed("change_character")):
    var new_character = Global.get_next_character();
    var old_character = target;
    var character_parent = old_character.get_parent();
    character_parent.add_child(new_character);
    target_character = new_character;
    set_new_target();
    
    # Copy important state
    new_character.position.x = old_character.position.x;
    new_character.position.y = old_character.position.y;
    
    var new_sprite = new_character.find_child("Sprite");
    var old_sprite = old_character.find_child("Sprite");
    if(new_sprite && old_sprite): new_sprite.scale.x = old_sprite.scale.x;
    
    var new_dash = new_character.find_child("Dash");
    var old_dash = old_character.find_child("Dash");
    if(new_dash && old_dash): new_dash.scale.x = old_dash.scale.x;
    
    # Remove old character
    character_parent.remove_child(old_character);
    old_character.queue_free();
  #end if
#end check_for_change
