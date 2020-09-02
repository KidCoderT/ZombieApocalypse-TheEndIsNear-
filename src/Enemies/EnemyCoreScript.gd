extends Sprite

export (int) var speed = 75
export (int) var health = 3
export (int) var points = 10
export (int) var knock_back = 600

var i_am_stun = false
var velocity = Vector2()
var blood_particles = preload("res://src/Enemies/BloodParticles.tscn")
var hurt_blood_particles = preload("res://src/Enemies/SmallBloodParticlesNode.tscn")

onready var current_color = modulate
onready var health_bar = $HealthBar/HealthBar


func _ready():
	health_bar.max_value = health

func basic_enemy_movement_towards_the_player(delta):
	if GlobalScript.player != null and !i_am_stun:
		velocity = global_position.direction_to(GlobalScript.player.position)
		global_position += velocity * speed * delta
	elif i_am_stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * delta
	
	health_bar.value = health
	
	if GlobalScript.player.position.x > global_position.x:
		set_flip_h(false)
	elif GlobalScript.player.position.x < global_position.x:
		set_flip_h(true)

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Player"):
		velocity *= -1 * (knock_back * 75/100)
		$Stun_Timer.start()
		i_am_stun = true
	if area.is_in_group("Bullet"):
		modulate = Color("eee5e5")
		velocity *= -1 * knock_back
		$Stun_Timer.start()
		i_am_stun = true
		health = health - area.get_parent().damage
		area.get_parent().queue_free()
		
		if health <= 0:
			GlobalScript.score += points
			if GlobalScript.node_creation_parent != null:
				var blood_particle_instance = GlobalScript.instancing_node(hurt_blood_particles, global_position, GlobalScript.node_creation_parent)
				blood_particle_instance.rotation = velocity.angle()
				blood_particle_instance.modulate = Color.from_hsv(current_color.h, current_color.v, 0.50)
				
				blood_particle_instance = GlobalScript.instancing_node(blood_particles, global_position, GlobalScript.node_creation_parent)
				blood_particle_instance.rotation = velocity.angle()
				blood_particle_instance.modulate = Color.from_hsv(current_color.h, 0.75, current_color.v)
			
			get_parent().number_of_zombies_killed += 1
			queue_free()
		
		$AnimationPlayer.play("healthshow")
		yield(get_tree().create_timer(0.4), "timeout")
		$AnimationPlayer.play("rest")
	

func _on_Stun_Timer_timeout():
	modulate = current_color
	i_am_stun = false

