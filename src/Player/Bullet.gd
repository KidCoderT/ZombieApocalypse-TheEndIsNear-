extends Sprite

export (bool) var look_once = true
export (int) var bullet_speed = 300

var damage
var velocity = Vector2(1, rand_range(-0.01, 0.01))

func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		
		look_once = false
	
	global_position += velocity.rotated(rotation) *  bullet_speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
