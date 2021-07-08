extends "res://Cenas/Enemys/Enemy_shooter_chaser.gd"

onready var shoot_animation = $ShootAnimation
onready var Bullet = preload("res://Cenas/Bullets/Enemy_pistol_bullet.tscn")
var current_rotation

func _ready():
	set_default_attributes(100, 90, 5, 20)
	set_default_range()

func _process(delta):
	movimentation(delta)
	set_default_rotation()

func shoot():
	shoot_animation.play("Shoot")
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position))
	get_parent().add_child(bullet)