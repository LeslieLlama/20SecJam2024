extends Node

var high_score : int = 27


func _ready() -> void:
	Signals.SaveGame.connect(save_game)
	Signals.LoadGame.connect(load_game)


func save():
	var save_dict = {
		"high_score" : high_score
	}
	return save_dict
	
func save_game():
	high_score = Globals.high_score
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	save_game.store_line(json_string)
	print("game saved!")
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line() 
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		Globals.high_score = node_data["high_score"]
		Signals.DataLoaded.emit()
	print("game loaded!")
