extends Sprite

export (String) var power_up_name
export (String) var variables_name_in_player_for_changing
export (float) var player_variables_value_for_change
export (float) var duration 	

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().set(variables_name_in_player_for_changing, player_variables_value_for_change)
		area.get_parent().power_ups_for_reseting.append(power_up_name)
		area.get_parent().get_node("PowerUpCoolDownTimer").wait_time = duration
		area.get_parent().get_node("PowerUpCoolDownTimer").start()
		queue_free()
