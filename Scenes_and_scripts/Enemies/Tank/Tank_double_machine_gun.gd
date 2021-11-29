extends Node2D

onready var Bullet = preload("res://Scenes_and_scripts/Bullets/Tank_machine_gun_bullet.tscn")
onready var left_gun_pos = $Left_gun_pos
onready var right_gun_pos = $Right_gun_pos
export (float) var shoot_delay
export (int) var damage
const rotation_fix = PI / 2
var left_gun = true


func _ready():
	$Shoot_timer.wait_time = shoot_delay

func _process(delta):
	rotation = (Game.Player.global_position - global_position).angle() + rotation_fix - get_parent().rotation

func shoot(initial_pos, animation_name):
	$AnimationPlayer.play(animation_name)
	var bullet = Bullet.instance()
	bullet.initialize_bullet(initial_pos, damage, global_position.direction_to(Game.Player.global_position))
	get_parent().get_parent().call_deferred("add_child", bullet)

func _on_Shoot_timer_timeout():
	if left_gun:
		shoot(left_gun_pos.global_position, "left_gun_shoot")
		left_gun = false
	else:
		shoot(right_gun_pos.global_position, "right_gun_shoot")
		left_gun = true
