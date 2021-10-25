extends "res://Scenes_and_scripts/Enemies/Enemy_shooter_chaser.gd"

onready var shoot_animation = $ShootAnimation
onready var shotgun_shoot_sound = preload("res://Sound/Effects/Weapons/Enemies/enemy-shotgun-shoot.wav")
onready var Bullet = preload("res:///Scenes_and_scripts/Bullets/Enemy_shotgun_bullet.tscn")
export (float) var angle
export (int) var qnt_bullets
var current_rotation

func on_ready():
	pass

func on_process(delta):
	movimentation(delta)
	set_default_rotation()

func shoot():
	shoot_animation.play("Shoot")
	SoundSystem.play_sound_effect(shotgun_shoot_sound)
	for i in range(qnt_bullets):
		instantiate_bullet(angle / 2 - (angle / (qnt_bullets - 1) * i))

func instantiate_bullet(extra_angle):
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position).rotated(extra_angle))
	get_parent().add_child(bullet)
