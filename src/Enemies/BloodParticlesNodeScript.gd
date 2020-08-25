extends Node2D
var random = RandomNumberGenerator.new()

var alpha  = 1
var fade = false

func _ready():
	$Fade_out_timer.wait_time = random.randf_range(1, 3)

func _process(_delta):
	if fade:
		alpha = lerp(alpha, 0, 0.1)
		modulate.a = alpha
	
	if modulate.a <= 0:
		queue_free()

func _on_Fade_out_timer_timeout():
	fade = true
