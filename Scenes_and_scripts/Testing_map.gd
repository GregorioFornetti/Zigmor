extends Node2D

onready var upgrade_shop = $Upgrade_shop
onready var Pause_menu = preload("res://Scenes_and_scripts/Interfaces/Menus/Pause_menu.tscn")
onready var Menu_music = preload("res://Sound/Musics/main-menu-music.wav")
onready var Pause_sound = preload("res://Sound/Effects/Interface/pause.wav")

func _unhandled_input(event):
	if event.is_action_pressed("open_shop"):
		upgrade_shop.open_shop()
		Game.current_status = Game.status.SHOPPING
		if Game.current_difficulty != Game.difficulties.HARD:
			get_tree().paused = true
			SoundSystem.play_pause_music()
	
	if event.is_action_pressed("ui_cancel"):
		var pause_menu = Pause_menu.instance()
		add_child(pause_menu)
		Game.current_status = Game.status.PAUSED
		get_tree().paused = true
		SoundSystem.play_sound_effect(Pause_sound)
		SoundSystem.play_pause_music()

