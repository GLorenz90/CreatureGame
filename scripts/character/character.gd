extends CharacterBody2D
class_name PlayerCharacter

@export var SPEED := 500.0;
@export var JUMP_VELOCITY := 400.0;
@export var CAN_FLY := true;
@export var MAX_SPEED := 1000;
@export var ABILITY_1 := Global.ABILITIES.JUMP;
@export var ABILITY_2 := Global.ABILITIES.SING;
@export var MAX_COYOTE_TIME := 0.2;
@export var MAX_BUSY_TIME = 1.0;

#calculated
var h_input := 0.0;
var v_input := 0.0;
var ability_1_input := false;
var ability_2_input := false;

var target_velocity := Vector2(0,0);
const emote := preload("res://scenes/characters/abilities/emote.tscn");
const fireball := preload("res://scenes/characters/abilities/fireball.tscn");

#flags
var is_busy := false;
var is_charging := false;

func stop_all_abilities():
  stop_charge();
#end stop_all_abilities();

#timers
var busy_time = MAX_BUSY_TIME;
var coyote_time = MAX_COYOTE_TIME;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
  stop_all_abilities();
#end _ready

func _process(delta):
  get_inputs();
  update_timers(delta);
  update_velocity(delta);
  update_facing();
  process_ability_inputs();
  #animate();
  #inject_juice();

  move_and_slide();
#end _physics_process
  
func get_inputs():
  h_input = Input.get_axis("char_move_left","char_move_right");
  v_input = Input.get_axis("char_move_up", "char_move_down") if CAN_FLY else 0.0;
  ability_1_input = Input.is_action_just_pressed("char_ability_1");
  ability_2_input = Input.is_action_just_pressed("char_ability_2");
  target_velocity = Vector2(h_input, v_input).normalized() * SPEED;
#end get_inputs

func update_timers(delta):
  if(is_on_floor()):
    coyote_time = MAX_COYOTE_TIME;
  else:
    if (coyote_time > 0):
      coyote_time -= delta;
    #end if
  #end if
  
  if(busy_time <= 0):
    end_busy();
  else:
    busy_time -= delta;
  #end if
#end update_timers
func start_busy():
  is_busy = true;
  busy_time = MAX_BUSY_TIME;
#end start_busy

func end_busy():
  is_busy = false;
  busy_time = 0;
  stop_all_abilities();
#end end_busy

func update_velocity(delta):
  # Horizontal Movement
  
  if (is_charging):
    velocity.x = move_toward(velocity.x, $Sprite.scale.x * SPEED * 2, SPEED * delta * 10);   
    if (h_input && ((target_velocity.x > 0 && $Sprite.scale.x < 0) || (target_velocity.x < 0 && $Sprite.scale.x > 0))):
      end_busy(); # This stops all abilities
    #end if
  else:
    if (h_input):
      velocity.x = move_toward(velocity.x, target_velocity.x, SPEED * delta * 5); 
    else:
      velocity.x = move_toward(velocity.x, 0, SPEED * delta * 5);
    #end if
  #end if
    
  # Vertical Movement
  if CAN_FLY:
    if v_input:
      velocity.y = move_toward(velocity.y, target_velocity.y, SPEED * delta * 5);
    else:
      velocity.y = move_toward(velocity.y, 0, SPEED * delta * 5);
    #end if
  else: # not CAN_FLY
    if not is_on_floor():
      velocity.y = min(MAX_SPEED, velocity.y + (gravity * delta))
    #end if
  #end if
#end update_velocity

func update_facing():
  if velocity.x > 0:
    $Sprite.scale.x = 1;
    $Dash.scale.x = 1;
  #end if
  if velocity.x < 0:
    $Sprite.scale.x = -1;
    $Dash.scale.x = -1;
  #end if
#end update_facing

func process_ability_inputs():
    if(ability_1_input): perform_action(ABILITY_1)
    if(ability_2_input): perform_action(ABILITY_2)
#end process_ability_inputs

func perform_action(action):
  #TODO: use match statement
  if(action == Global.ABILITIES.SING):
    var emote_instance = emote.instantiate()
    emote_instance.position = Vector2(0, -75);
    emote_instance.live_time = MAX_BUSY_TIME;
    add_child(emote_instance);
  #end if
  
  if(action == Global.ABILITIES.JUMP):
    #TODO: Buffer Time (input before landing)
    if(coyote_time > 0 || is_on_floor()):
      coyote_time = 0;
      velocity.y = JUMP_VELOCITY * -1;
      $JumpSound.pitch_scale = randf_range(.5,.75);
      $JumpSound.play();
    #end if
  #end if
  
  if(action == Global.ABILITIES.CHARGE):
    if(!is_busy):
      start_charge();
    #end if
  #end if
  
  if(action == Global.ABILITIES.FIRE):
    # TODO: put on busy timer, make many fireballs
    
    var fireball_instance = fireball.instantiate();
    fireball_instance.position = Vector2(position.x + randf_range(-10, 10), position.y + randf_range(-10, 10));
    
    fireball_instance.scale.x = $Sprite.scale.x;
    fireball_instance.MOVE_SPEED += SPEED;
    owner.add_child(fireball_instance);
  #end if
#end Perform_action

func start_charge():
  $Dash/Noise.pitch_scale = randf_range(.65, .85);
  $Dash/Noise.play();
  $Dash/Collision.disabled = false;
  $Dash.visible = true;
  is_charging = true;
  start_busy();
#end start_charge

func stop_charge():
  $Dash/Collision.disabled = true;
  $Dash.visible = false;
  is_charging = false;
#end stop_charge


func _on_dash_body_entered(body): #for some reason this triggers even if collision is disabled, after enabling it
  if(body.is_in_group("breakable") && !$Dash/Collision.disabled):
    body.queue_free();
    velocity.x /= 2;
    end_busy();
  #end if
#end _on_dash_body_entered
