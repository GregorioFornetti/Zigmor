extends Node2D

onready var upgrade_shop = $Upgrade_shop

func _input(event):
	if event.get_action_strength("open_shop"):
		upgrade_shop.open_shop()
		Game.current_status = Game.status.SHOPPING
		if Game.current_difficulty != Game.difficulties.HARD:
			get_tree().paused = true

func _ready():
	pass

