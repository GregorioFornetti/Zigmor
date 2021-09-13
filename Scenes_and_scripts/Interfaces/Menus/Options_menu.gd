extends Control

onready var res_options_dropdown = $Bottom_container/Res_options
onready var save_path = "user://opcoes.dat"
var selected_resolution_options

func _ready():
	var resolutions = ["1536x900", "1280x750", "1024x600", "768x450", "512x300"]
	var file = File.new()
	
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var options = file.get_var()
		selected_resolution_options = options.resolution
		var current_resolution = str(selected_resolution_options.window_size_x) + "x" + str(selected_resolution_options.window_size_y)
		res_options_dropdown.add_item("Tela cheia")
		res_options_dropdown.add_separator()
		# Selecionando a opção de resolução salva no arquivo de opções
		for resolution in resolutions:
			res_options_dropdown.add_item(resolution)
			if current_resolution == resolution:
				res_options_dropdown.select(get_dropdown_itemIdx_by_name(res_options_dropdown, resolution))
	
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


func get_dropdown_itemIdx_by_name(dropdown, name):
	# Retorna o indice do item dropdown pelo seu nome(texto)
	for i in range(dropdown.get_item_count()):
		if dropdown.get_item_text(i) == name:
			return i

func save_options():
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_var({
		"resolution": selected_resolution_options
	})
	file.close()
