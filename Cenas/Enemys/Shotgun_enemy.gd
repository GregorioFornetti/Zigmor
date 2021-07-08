extends "res://Cenas/Enemys/Enemy_shooter_chaser.gd"

onready var shoot_animation = $ShootAnimation
onready var Bullet = preload("res://Cenas/Bullets/Enemy_shotgun_bullet.tscn")
export (float) var angle
export (int) var qnt_bullets
var current_rotation

func _ready():
	set_default_attributes(100, 90, 5, 20)
	angle = deg2rad(angle)
	set_default_range()

func _process(delta):
	movimentation(delta)
	set_default_rotation()

func shoot():
	shoot_animation.play("Shoot")
	for i in range(qnt_bullets):
		instantiate_bullet(angle / 2 - (angle / (qnt_bullets - 1) * i))

func instantiate_bullet(extra_angle):
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position).rotated(extra_angle))
	get_parent().add_child(bullet)
