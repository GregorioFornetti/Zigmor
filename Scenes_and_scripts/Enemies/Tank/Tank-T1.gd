extends "res://Scenes_and_scripts/Enemies/Tank/Tank.gd"

func set_status():
	var health = 50 + Game.get_enemies_points() * 5
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 10 + int(Game.get_enemies_points() * 1.2)
	set_default_attributes(health, speed, damage)
