extends Node2D
signal pause_game
signal exit_game

export (Array, PackedScene) var enemies
export (Array, PackedScene) var power_ups

var can_create_zombies = true
var number_of_zombies_killed = 0
onready var player = $Player
onready var player_lives_label = $HUD/PlayerItems/PlayerLives
onready var pause_screen = $HUD/PauseScreen
onready var pause_button = $HUD/GamePlayUI/PauseButton
onready var zombies_killed_label = $HUD/PlayerItems/ZombiesKilled
onready var exit_button = $HUD/GamePlayUI/ExitButton
onready var shock_wave_animation = $HUD/ShockWave/PlayShockwave

func _ready():
	GlobalScript.score = 0
	GlobalScript.node_creation_parent = self
	self.connect("pause_game", pause_screen, "pause_or_unpause_game")
	player.connect("health_updated", $HUD/HealthBar, "_on_health_updated")
	player.connect("revive", self, "revive")

func _exit_tree():
	GlobalScript.node_creation_parent = self

func _on_EnemySpawnTimer_timeout():
	if can_create_zombies:
		var random_enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
		while random_enemy_position.x < 640 and random_enemy_position.x > -80 and random_enemy_position.y < 360 and random_enemy_position.y > -45:
			random_enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
		var enemy_number = round(rand_range(0, enemies.size() - 1))
		var enemy_instance = GlobalScript.instancing_node(enemies[enemy_number], random_enemy_position, self)
		$Player.connect("revive", enemy_instance, "queue_free")
		enemy_instance.z_index = -2

func _on_DifficultyTimer_timeout():
	if $EnemySpawnTimer.wait_time > 0.5:
		$EnemySpawnTimer.wait_time -= 0.05

func _on_PowerUpsSpawnTimer_timeout():
	var power_up_number = round(rand_range(0, power_ups.size() - 1))
	GlobalScript.instancing_node(power_ups[power_up_number], Vector2(rand_range(24, 616), rand_range(24, 336)), self)
	$PowerUpSpawnTimer.wait_time = rand_range(10, 20)
	$PowerUpSpawnTimer.start()

func _process(_delta):
	zombies_killed_label.text = "x  " + str(number_of_zombies_killed)
	if pause_button.pressed:
		emit_signal("pause_game")
	if exit_button.pressed:
		emit_signal("exit_game")
	player_lives_label.text = "x " + str(player.lives)

func revive():
	can_create_zombies = false
	shock_wave_animation.play("ShockWave")
	yield(get_tree().create_timer(3), "timeout")
	can_create_zombies = true
	
