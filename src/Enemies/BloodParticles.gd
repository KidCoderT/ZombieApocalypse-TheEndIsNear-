extends CPUParticles2D

func _on_Freeze_the_blood_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	get_parent().get_node("Fade_out_timer").start()
