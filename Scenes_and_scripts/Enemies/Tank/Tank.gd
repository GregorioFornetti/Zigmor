extends "res://Scenes_and_scripts/Enemies/Enemy_base.gd"

export var steer_force = 1.0
onready var Tank_bullet = preload("res://Scenes_and_scripts/Bullets/Tank_bullet.tscn")
onready var weapon_position = $TankHead/TankWeaponPosition
const rotation_fix = PI / 2
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var obstacle_list = []
var target_obstacle
var player_in_range = false

func on_ready():
	$Range/CollisionShape2D.shape.extents = (get_viewport_rect().size / 1.8)
	set_status()

func set_status():
	pass

func seek():
	var desired = ((Player.position - position).normalized() * attributes['speed'])
	return (desired - velocity).normalized() * steer_force

func on_process(delta):
	movimentation(delta)
	set_default_rotation()

func is_static_obstacle(obstacle):
	return "Stone" in obstacle.name or "Tree" in obstacle.name

func find_new_target_obstacle(new_obstacle = false):
	for obstacle in obstacle_list:
		if is_static_obstacle(obstacle) and (not new_obstacle or not obstacle == target_obstacle):
			target_obstacle = obstacle
			return
	target_obstacle = null

func set_default_rotation():
	rotation = velocity.angle() + rotation_fix
	$Range.rotation = -rotation
	if target_obstacle:
		rotate_tank_head(target_obstacle)
	else:
		rotate_tank_head(Player)

func rotate_tank_head(target):
	$TankHead.rotation = (target.global_position - global_position).angle() + rotation_fix - rotation

func movimentation(delta):
	if not obstacle_list:
		acceleration += seek()
		velocity += (acceleration * delta)
	else:
		velocity *= 0.99
	velocity = velocity.clamped(attributes['speed'])
	move_and_slide(velocity)


func _on_ObstacleDetectionArea_body_entered(body):
	if body != self:
		obstacle_list.append(body)
		find_new_target_obstacle()

func _on_ObstacleDetectionArea_body_exited(body):
	if body != self:
		obstacle_list.erase(body)
		find_new_target_obstacle()


func _on_ShootTimer_timeout():
	if target_obstacle:
		shoot(target_obstacle)
		find_new_target_obstacle(true)
	elif player_in_range:
		shoot(Player)


func shoot(target):
	$AnimationPlayer.play("Shoot")
	var tank_bullet = Tank_bullet.instance()
	tank_bullet.rotation = $TankHead.rotation + rotation
	tank_bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(target.global_position))
	get_parent().add_child(tank_bullet)


func _on_Range_body_entered(_body):
	player_in_range = true

func _on_Range_body_exited(body):
	player_in_range = false
