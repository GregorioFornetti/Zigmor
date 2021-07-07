extends "res://Cenas/Enemys/Enemy_shooter_chaser.gd"

onready var Bullet = preload("res://Cenas/Bullets/Enemy_pistol_bullet.tscn")
const rotation_fix = PI / 2
var current_rotation

func _ready():
	set_default_attributes(100, 90, 5, 20)

func _process(delta):
	movimentation(delta)
	rotation = (Player.global_position - global_position).angle() + rotation_fix

func shoot():
	var bullet = Bullet.instance()
	bullet.initialize_bullet($Weapon_pos.global_position, attributes['damage'], global_position.direction_to(Player.global_position))
	get_parent().add_child(bullet)
