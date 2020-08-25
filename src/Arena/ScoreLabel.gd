extends Label

func _process(delta):
	text = "Score: " + String(GlobalScript.score)
