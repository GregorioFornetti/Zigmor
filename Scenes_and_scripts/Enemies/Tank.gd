extends "res://Scenes_and_scripts/Enemies/Enemy_base.gd"

export var steer_force = 1.0
const rotation_fix = PI / 2
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func on_ready():
	var health = 20 + Game.get_enemies_points() * 4
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 5 + Game.get_enemies_points()
	set_default_attributes(health, speed, damage)

func seek():
	var corretion = get_angle_to_dodge_obstacles($CollisionShape2D.shape.extents.x, 250)
	var desired = ((Player.position - position).normalized() * attributes['speed']).rotated(deg2rad(corretion))
	return (desired - velocity).normalized() * steer_force

func on_process(delta):
	movimentation(delta)
	set_default_rotation()

func set_default_rotation():
	rotation = velocity.angle() + rotation_fix
	$TankHead.rotation = (Player.global_position - global_position).angle() + rotation_fix - rotation
	

func movimentation(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(attributes['speed'])
	move_and_slide(velocity)
