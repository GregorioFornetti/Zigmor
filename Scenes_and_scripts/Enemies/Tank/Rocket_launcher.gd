extends Node2D

onready var Rocket = preload("res://Scenes_and_scripts/Bullets/Rocket.tscn")
export (float) var launch_delay
export (int) var damage

func _ready():
	$Launch_timer.wait_time = launch_delay

func launch():
	var rocket = Rocket.instance()
	rocket.initialize_bullet(global_position, damage)
	get_parent().get_parent().call_deferred("add_child", rocket)

func _on_Launch_timer_timeout():
	launch()
