extends Control

func _ready():
	pass 


func _on_Btn_play_pressed():
	get_tree().change_scene("res://Cenas/Menus/Play_menu.tscn")

func _on_Btn_options_pressed():
	pass

func _on_Btn_credits_pressed():
	get_tree().change_scene("res://Cenas/Menus/Credits_menu.tscn")

func _on_Btn_exit_pressed():
	get_tree().quit()
