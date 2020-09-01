extends Sprite
signal health_updated(health)
signal killed()

export (int) var damage = 1
export (int) var speed = 200
export (Array, Texture) var images
export (float) var shooting_reload_speed = 0.1
export (float) var max_health = 100

var can_fire := true
var is_dead := false
var texture_number = 0
var velocity := Vector2()
var default_damage = damage
var default_shooting_reload_speed = shooting_reload_speed
var bullet = preload("res://src/Player/Bullet.tscn")
var power_ups_for_reseting = []

onready var health = max_health setget _set_health

func _ready():
	GlobalScript.player = self

func _exit_tree():
	GlobalScript.player = null

func _process(delta):
	velocity.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	velocity.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	
	velocity = velocity.normalized()
	
	global_position.x = clamp(global_position.x, 24, 616)
	global_position.y = clamp(global_position.y, 24, 336)
	
	if !is_dead:
		global_position += velocity * speed * delta
	
	if Input.is_action_pressed("fire") and GlobalScript.node_creation_parent != null and can_fire and is_dead == false:
		var bullet_instance = GlobalScript.instancing_node(bullet, global_position, GlobalScript.node_creation_parent)
		bullet_instance.damage = damage
		texture_number = 1
		$Reload_Timer.start()
		can_fire = false
	
	texture = images[texture_number]
	
	if get_global_mouse_position().x > global_position.x:
		set_flip_h(false)
	elif get_global_mouse_position().x < global_position.x:
		set_flip_h(true)

func _on_Reload_Timer_timeout():
	can_fire = true
	$Reload_Timer.wait_time = shooting_reload_speed
	if !is_dead:
		texture_number = 0

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Enemy") and $InvulnerabilityTimer.is_stopped():
		$InvulnerabilityTimer.start()
		_set_health(health - 10)
		texture_number = 2
		$PlayerEffectsAnimations.play("damage")
		$PlayerEffectsAnimations.play("flash")

func _on_PowerUpCoolDownTimer_timeout():
	if power_ups_for_reseting.find("faster_reloading") != null:
		shooting_reload_speed = default_shooting_reload_speed
		power_ups_for_reseting.erase("faster_reloading")
	if power_ups_for_reseting.find("higher_damage") != null:
		damage = default_damage
		power_ups_for_reseting.erase("higher_damage")

func player_has_been_killed():
	visible = false
	is_dead = true
	GlobalScript.save_game_data()
	get_tree().reload_current_scene()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			player_has_been_killed()
			emit_signal("killed")

func _on_InvulnerabilityTimer_timeout():
	$PlayerEffectsAnimations.play("rest")
	texture_number = 0
