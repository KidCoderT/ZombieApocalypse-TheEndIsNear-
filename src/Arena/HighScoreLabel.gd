extends Label

var addon_text = "YourHighScore: "

func _ready():
	GlobalScript.load_game()

func _process(delta):
	text = addon_text + String(GlobalScript.highscore)
	if GlobalScript.highscore < GlobalScript.score:
		GlobalScript.highscore = GlobalScript.score
		addon_text = "New HighScore!!!: "
