extends Area2D

@export var MAX_LIVE_TIME := .75;
@export var MOVE_SPEED := 150.0;
@export var AMPLITUDE := 70.0;
@export var FREQUENCY := 15.0;

var cur_live_time := 0.0;
var cur_live_progress := 0.0;
var timing_offset := 0.0;
var y_offset := 0.0;
var starting_y = position.y;

# Called when the node enters the scene tree for the first time.
func _ready():
  timing_offset = deg_to_rad(randf_range(0.0, 360.0));
  starting_y = position.y;
  rotation_degrees = randf_range(0.0, 360.0);
#end _ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  cur_live_time += delta;
  cur_live_progress = cur_live_time / MAX_LIVE_TIME;
  y_offset = sin((cur_live_time + timing_offset) * FREQUENCY) * AMPLITUDE * cur_live_progress;

  position.y = starting_y + y_offset;
  position.x += MOVE_SPEED * delta * scale.x;
  $Sprite2D.modulate = Color(1, 1, 1, 1-cur_live_progress**10)
  if(cur_live_time >= MAX_LIVE_TIME): queue_free();
#end _process


func _on_body_entered(body):
  if(body.is_in_group("burnable")):
    body.queue_free();
  pass # Replace with function body.
