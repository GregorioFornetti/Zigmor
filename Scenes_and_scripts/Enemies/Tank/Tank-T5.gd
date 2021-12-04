extends "res://Scenes_and_scripts/Enemies/Tank/Tank.gd"

func set_status():
	var health = 250 + Game.get_enemies_points() * 25
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 10 + int(Game.get_enemies_points() * 1.2)
	set_default_attributes(health, speed, damage)
	
	$Tank_single_machine_gun.damage = damage
	$Tank_single_machine_gun2.damage = damage
	$Tank_single_machine_gun3.damage = damage
	$Tank_single_machine_gun4.damage = damage
	$Rocket_launcher.damage = damage
	$Tank_double_machine_gun.damage = damage
