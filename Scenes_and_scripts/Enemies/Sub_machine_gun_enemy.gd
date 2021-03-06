extends "res://Scenes_and_scripts/Enemies/Shooter_single_bullet.gd"

func on_ready():
	var health = 40 + Game.get_enemies_points() * 2
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 5 + Game.get_enemies_points()
	set_default_attributes(health, speed, damage)
	set_default_range()
