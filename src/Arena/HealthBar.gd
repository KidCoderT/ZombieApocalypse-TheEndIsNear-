extends Control

onready var update_tween = $UpdateTween
onready var healthbar_over = $HealthBarOver
onready var healthbar_under = $HealthBarUnder

export (Color) var under_bar_healthy_color = Color("ffffff")
export (Color) var under_bar_warning_color = Color("afff00")
export (Color) var under_bar_danger_color = Color("ff0000")
export (Color) var progress_bar_healthy_color = Color.green
export (Color) var progress_bar_warning_color = Color.yellow
export (Color) var progress_bar_danger_color = Color.red

export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2
export (bool) var will_pulse = false

func _on_health_updated(health):
	healthbar_over.value = health
	update_tween.interpolate_property(healthbar_under, "value", healthbar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	
	_assign_color(health)

func _assign_color(health):
	if health <= healthbar_over.max_value * danger_zone:
		healthbar_over.tint_progress = progress_bar_danger_color
		healthbar_under.tint_under = under_bar_danger_color
	elif health <= healthbar_over.max_value * caution_zone:
		healthbar_over.tint_progress = progress_bar_warning_color
		healthbar_under.tint_under = under_bar_warning_color
	else:
		healthbar_over.tint_progress = progress_bar_healthy_color
		healthbar_under.tint_under = under_bar_healthy_color
	
	
