extends "res://Scenes_and_scripts/Bullets/Bullet.gd"

onready var Explosion = preload("res://Scenes_and_scripts/Explosions/Explosion.tscn")

func explode():
	var explosion = Explosion.instance()
	explosion.damage = damage
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	queue_free()


func _on_Life_timer_timeout():
	explode()

func _on_Hitbox_area_entered(_area):
	explode()
