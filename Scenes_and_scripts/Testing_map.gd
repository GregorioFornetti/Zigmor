extends Node2D

onready var upgrade_shop = $Upgrade_shop
onready var Pause_menu = preload("res://Scenes_and_scripts/Interfaces/Menus/Pause_menu.tscn")


func _unhandled_input(event):
	if event.is_action_pressed("open_shop"):
		upgrade_shop.open_shop()
		Game.current_status = Game.status.SHOPPING
		if Game.current_difficulty != Game.difficulties.HARD:
			get_tree().paused = true
	
	if event.is_action_pressed("ui_cancel"):
		var pause_menu = Pause_menu.instance()
		add_child(pause_menu)
		Game.current_status = Game.status.PAUSED
		get_tree().paused = true

