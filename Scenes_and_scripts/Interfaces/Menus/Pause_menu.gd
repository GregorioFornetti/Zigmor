extends CanvasLayer

onready var Options_menu = preload("res://Scenes_and_scripts/Interfaces/Menus/Options_menu.tscn")

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		continue_game()

func continue_game():
	get_tree().paused = false
	Game.current_status = Game.status.PLAYING
	queue_free()

func _on_Btn_continue_pressed():
	continue_game()

func _on_Btn_options_pressed():
	var options_menu = Options_menu.instance()
	add_child(options_menu)

func _on_Btn_close_pressed():
	get_tree().paused = false
	Game.current_status = Game.status.MENU
	get_tree().change_scene("res://Scenes_and_scripts/Interfaces/Menus/Play_menu.tscn")
