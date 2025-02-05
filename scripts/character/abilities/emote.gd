extends Node2D

var live_time = 2.0; # Should be set by parent when instantiated

func _ready():
  $Noise.pitch_scale = randf_range(.85, 1.15);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  live_time -= delta;
  if(live_time <= 0):
    queue_free();
    
  # Fade emote
  # Animate emote
#end _process
