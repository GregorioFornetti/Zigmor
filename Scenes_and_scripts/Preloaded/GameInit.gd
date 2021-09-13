extends Node

onready var options_path = "user://opcoes.dat"

func _ready():
	var file = File.new()
	
	if file.file_exists(options_path):
		file.open(options_path, File.READ)
		var options = file.get_var()
		GeneralCommands.apply_resolution(options.resolution)
	else:
		file.open(options_path, File.WRITE)
		file.store_var({
			"resolution" : {
				"full_screen" : false,
				"window_size_x" : 1024,
				"window_size_y" : 600
			}
		})
	
	file.close()
