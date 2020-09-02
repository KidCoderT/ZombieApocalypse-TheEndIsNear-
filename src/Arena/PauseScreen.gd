extends Control

onready var unpause_button = $Unpause

func pause_or_unpause_game():
	var pause_state = not get_tree().paused
	get_tree().paused = not get_tree().paused
	visible = pause_state

func _process(_delta):
	if get_tree().paused:
		if unpause_button.pressed:
			pause_or_unpause_game()
