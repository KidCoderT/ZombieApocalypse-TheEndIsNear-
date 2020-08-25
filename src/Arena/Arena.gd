extends Node2D

export (Array, PackedScene) var enemies
export (Array, PackedScene) var power_ups

func _ready():
	GlobalScript.node_creation_parent = self
	GlobalScript.score = 0

func _exit_tree():
	GlobalScript.node_creation_parent = self

func _on_EnemySpawnTimer_timeout():
	var random_enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	while random_enemy_position.x < 640 and random_enemy_position.x > -80 and random_enemy_position.y < 360 and random_enemy_position.y > -45:
		random_enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	var enemy_number = round(rand_range(0, enemies.size() - 1))
	GlobalScript.instancing_node(enemies[enemy_number], random_enemy_position, self)

func _on_DifficultyTimer_timeout():
	if $EnemySpawnTimer.wait_time > 0.5:
		$EnemySpawnTimer.wait_time -= 0.05

func _on_PowerUpsSpawnTimer_timeout():
	var power_up_number = round(rand_range(0, power_ups.size() - 1))
	GlobalScript.instancing_node(power_ups[power_up_number], Vector2(rand_range(24, 616), rand_range(24, 336)), self)
	$PowerUpSpawnTimer.wait_time = rand_range(10, 20)
	$PowerUpSpawnTimer.start()
