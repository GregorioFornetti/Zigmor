extends "res://Scenes_and_scripts/Enemies/Shotgun_enemy.gd"

func on_ready():
	var health = 45 + Game.get_enemies_points() * 9
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 4 + int(Game.get_enemies_points() / 2)
	set_default_attributes(health, speed, damage)
	angle = deg2rad(angle)
	set_default_range()

