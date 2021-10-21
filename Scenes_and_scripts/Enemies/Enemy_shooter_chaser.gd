extends "res://Scenes_and_scripts/Enemies/Enemy_base.gd"

onready var range_colision = $Range/CollisionShape2D
onready var weapon_position = $Weapon_pos
const rotation_fix = PI / 2
onready var timer_shoot = $Timer_shoot

func shoot():
	pass

func movimentation(delta):
	var dodge_rotation = get_angle_to_dodge_obstacles($CollisionShape2D.shape.radius, 100)
	move_and_slide(global_position.direction_to(Player.global_position).rotated(deg2rad(dodge_rotation)) * attributes['speed'] * delta * 50)

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
