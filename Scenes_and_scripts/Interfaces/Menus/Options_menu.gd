extends Control

onready var res_options_dropdown = $Bottom_container/Options_content/Resolution_box/Res_options
onready var master_bus_index = AudioServer.get_bus_index("Master")
onready var musics_bus_index = AudioServer.get_bus_index("Musics")
onready var effects_bus_index = AudioServer.get_bus_index("Effects")
onready var master_volume_slider = $Bottom_container/Options_content/Audio_box/Volume_box/Master_volume_box/Slider_master_volume
onready var musics_volume_slider = $Bottom_container/Options_content/Audio_box/Volume_box/Music_volume_box/Slider_music_volume
onready var effects_volume_slider = $Bottom_container/Options_content/Audio_box/Volume_box/Sfx_volume_box/Slider_sfx_volume

var save_path = "user://opcoes.dat"
var selected_resolution_options

func _ready():
	var file = File.new()
	
	master_volume_slider.max_value = SoundSystem.MASTER_MAX_VOLUME
	master_volume_slider.min_value = SoundSystem.MASTER_MIN_VOLUME
	musics_volume_slider.max_value = SoundSystem.MUSICS_MAX_VOLUME
	musics_volume_slider.min_value = SoundSystem.MUSICS_MIN_VOLUME
	effects_volume_slider.max_value = SoundSystem.EFFECTS_MAX_VOLUME
	effects_volume_slider.min_value = SoundSystem.EFFECTS_MIN_VOLUME
	
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var options = file.get_var()
		
		# Configurando resolução
		var resolutions = ["1536x900", "1280x750", "1024x600", "768x450", "512x300"]
		selected_resolution_options = options.resolution
		var current_resolution = str(selected_resolution_options.window_size_x) + "x" + str(selected_resolution_options.window_size_y)
		res_options_dropdown.add_item("Tela cheia")
		res_options_dropdown.add_separator()
		# Selecionando a opção de resolução salva no arquivo de opções
		for resolution in resolutions:
			res_options_dropdown.add_item(resolution)
			if current_resolution == resolution:
				res_options_dropdown.select(get_dropdown_itemIdx_by_name(res_options_dropdown, resolution))
		
		# Configurando sliders de audio (colocando o ponto do slider na posição configurada)
		var selected_audio_options = options.audio
		master_volume_slider.value = selected_audio_options['master_volume']
		musics_volume_slider.value = selected_audio_options['musics_volume']
		effects_volume_slider.value = selected_audio_options['effects_volume']
		
	
	file.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_options()

func _on_Btn_exit_pressed():
	save_options()
	queue_free()

func _on_Res_options_item_selected(index):
	var selected_option = res_options_dropdown.get_item_text(index)
	if selected_option == "Tela cheia":
		selected_resolution_options = {"full_screen": true, 
									   "window_size_x": 0,
									   "window_size_y": 0}
	else:
		selected_resolution_options = {"full_screen": false, 
									   "window_size_x": int(selected_option.split("x")[0]), 
									   "window_size_y": int(selected_option.split("x")[1])}
	GeneralCommands.apply_resolution(selected_resolution_options)

func _on_Slider_master_volume_value_changed(value):
	SoundSystem.apply_new_volume(master_bus_index, value, SoundSystem.MASTER_MIN_VOLUME)

func _on_Slider_music_volume_value_changed(value):
	SoundSystem.apply_new_volume(musics_bus_index, value, SoundSystem.MUSICS_MIN_VOLUME)

func _on_Slider_sfx_volume_value_changed(value):
	SoundSystem.apply_new_volume(effects_bus_index, value, SoundSystem.EFFECTS_MIN_VOLUME)


func get_dropdown_itemIdx_by_name(dropdown, name):
	# Retorna o indice do item dropdown pelo seu nome(texto)
	for i in range(dropdown.get_item_count()):
		if dropdown.get_item_text(i) == name:
			return i

func save_options():
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_var({
		"audio": {
			"master_volume": master_volume_slider.value,
			"musics_volume": musics_volume_slider.value,
			"effects_volume": effects_volume_slider.value
		},
		"resolution": selected_resolution_options
	})
	file.close()


func _on_Btn_controls_pressed():
	$Bottom_container/Options_content.visible = false
	$Bottom_container/Controls_content.visible = true

func _on_Btn_return_pressed():
	$Bottom_container/Options_content.visible = true
	$Bottom_container/Controls_content.visible = false
