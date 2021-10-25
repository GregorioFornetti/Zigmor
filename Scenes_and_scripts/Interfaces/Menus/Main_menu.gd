extends Control

onready var Options_menu = preload("res://Scenes_and_scripts/Interfaces/Menus/Options_menu.tscn")

func _on_Btn_play_pressed():
	get_tree().change_scene("res://Scenes_and_scripts/Interfaces/Menus/Play_menu.tscn")

func _on_Btn_options_pressed():
	var options_menu = Options_menu.instance()
	add_child(options_menu)

func _on_Btn_credits_pressed():
	get_tree().change_scene("res://Scenes_and_scripts/Interfaces/Menus/Credits_menu.tscn")

func _on_Btn_exit_pressed():
	get_tree().quit()
