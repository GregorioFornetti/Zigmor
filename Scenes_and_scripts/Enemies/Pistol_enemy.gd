extends "res://Scenes_and_scripts/Enemies/Enemy_shooter_chaser.gd"

onready var shoot_animation = $ShootAnimation
onready var Bullet = preload("res:///Scenes_and_scripts/Bullets/Enemy_pistol_bullet.tscn")
onready var pistol_sound = preload("res://Sound/Effects/Weapons/enemy-pistol-shoot.wav")
var current_rotation

func on_ready():
	set_default_attributes(20, 90, 5, 20)
	set_default_range()

func on_process(delta):
	movimentation(delta)
	set_default_rotation()

func shoot():
	shoot_animation.play("Shoot")
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position))
	get_parent().add_child(bullet)
	SoundSystem.play_sound_effect(pistol_sound)
