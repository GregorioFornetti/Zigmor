extends "res://Scenes_and_scripts/Enemies/Enemy_base.gd"

onready var range_colision = $Range/CollisionShape2D
onready var weapon_position = $Weapon_pos
const rotation_fix = PI / 2
onready var timer_shoot = $Timer_shoot

func shoot():
	pass

func movimentation(delta):
	move_and_collide(global_position.direction_to(Player.global_position) * attributes['speed'] * delta)

func set_default_range():
	$Range/CollisionShape2D.shape.extents = get_viewport_rect().size / 2

func set_default_rotation():
	rotation = (Player.global_position - global_position).angle() + rotation_fix
	range_colision.rotation = -rotation

func _on_Range_body_entered(_body):
	timer_shoot.start()


func _on_Range_body_exited(_body):
	timer_shoot.stop()


func _on_Timer_shoot_timeout():
	shoot()