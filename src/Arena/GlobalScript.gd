extends Node

var score = 0
var player = null
var highscore = 0
var node_creation_parent = null

func instancing_node(node, position, parent):
	var new_node_instance = node.instance()
	parent.add_child(new_node_instance)
	new_node_instance.global_position = position
	return new_node_instance

func save():
	var save_dict = {
		"highscore": highscore
	}
	return save_dict

func save_game_data():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("res://src/gamedata.save", File.WRITE, "enc")
	save_game.store_line(to_json(save()))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://src/gamedata.save"):
		print("Error: the Save file does not exit")
		return
	save_game.open_encrypted_with_pass("res://src/gamedata.save", File.READ, "enc")
	var current_line = parse_json(save_game.get_line())
	highscore = current_line["highscore"]
	save_game.close()
