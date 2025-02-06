extends RigidBody2D

var lifeTime = randf_range(2.0, 2.5);
var tween: Tween;

func _ready():
  var vector = Vector2(randf_range(-150, 150), randf_range(-150, 150));
  var angle = randf_range(0,360);
  var scaleMagnetude = randf_range(.15 ,.5);
  $Sprite.scale = Vector2(scaleMagnetude,scaleMagnetude);
  apply_central_impulse(vector);
  rotation_degrees = angle;
  
  tween = create_tween();
  tween.tween_interval(lifeTime/2)
  tween.tween_property(self, "modulate:a", 0, lifeTime/2);
  tween.tween_callback(func callback(): queue_free());
  pass
