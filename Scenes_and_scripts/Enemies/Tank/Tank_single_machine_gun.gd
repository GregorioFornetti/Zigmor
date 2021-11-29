extends Node2D

onready var Bullet = preload("res://Scenes_and_scripts/Bullets/Tank_machine_gun_bullet.tscn")
onready var animation_player = $AnimationPlayer
onready var weapon_pos = $Position2D
export (float) var speed
export (bool) var anticlockwise
export (float) var max_rotation
export (float) var shoot_delay
export (int) var damage
var max_angle_counter = 0

func _ready():
	speed = deg2rad(speed)
	max_rotation = deg2rad(max_rotation)
	$Shoot_timer.wait_time = shoot_delay

func _process(delta):
	if anticlockwise:
		rotation -= speed * delta
	else:
		rotation += speed * delta
	max_angle_counter += speed * delta
	
	if max_angle_counter >= max_rotation:
		max_angle_counter -= max_rotation
		max_angle_counter = -max_angle_counter
		anticlockwise = not anticlockwise

func _on_Shoot_timer_timeout():
	shoot()

func shoot():
	animation_player.play("Shoot")
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_pos.global_position, damage, global_position.direction_to(weapon_pos.global_position))
	get_parent().get_parent().call_deferred("add_child", bullet)
