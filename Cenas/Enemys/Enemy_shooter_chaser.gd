extends "res://Cenas/Enemys/Enemy_base.gd"

onready var timer_shoot = $Timer_shoot

func shoot():
	pass

func movimentation(delta):
	move_and_collide(global_position.direction_to(Player.global_position) * attributes['speed'] * delta)


func _on_Range_body_entered(_body):
	timer_shoot.start()


func _on_Range_body_exited(_body):
	timer_shoot.stop()


func _on_Timer_shoot_timeout():
	shoot()
