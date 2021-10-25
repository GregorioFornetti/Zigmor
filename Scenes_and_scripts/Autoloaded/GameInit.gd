extends Node

onready var options_path = "user://opcoes.dat"
onready var Menu_music = preload("res://Sound/Musics/main-menu-music.wav")

func _ready():
	var file = File.new()
	
	if file.file_exists(options_path):
		file.open(options_path, File.READ)
		var options = file.get_var()
		GeneralCommands.apply_resolution(options.resolution)
		SoundSystem.apply_sound_configurations(options.audio)
		SoundSystem.play_music(Menu_music)
	else:
		file.open(options_path, File.WRITE)
		file.store_var({
			"resolution" : {
				"full_screen" : false,
				"window_size_x" : 1024,
				"window_size_y" : 600
			},
			"audio": {
				"master_volume": SoundSystem.MASTER_MAX_VOLUME,
				"musics_volume": (SoundSystem.MUSICS_MAX_VOLUME + SoundSystem.MUSICS_MIN_VOLUME) / 2,
				"effects_volume": (SoundSystem.EFFECTS_MAX_VOLUME + SoundSystem.EFFECTS_MIN_VOLUME) / 2
			}
		})
	
	file.close()
