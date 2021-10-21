extends "res://Scenes_and_scripts/Enemies/Enemy_shooter_chaser.gd"

onready var shoot_animation = $ShootAnimation
onready var Bullet = preload("res:///Scenes_and_scripts/Bullets/Enemy_pistol_bullet.tscn")
onready var pistol_shoot_sound = preload("res://Sound/Effects/Weapons/Enemies/enemy-pistol-shoot.wav")
var current_rotation

func on_ready():
	var health = 20 + Game.get_enemies_points() * 4
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 5 + Game.get_enemies_points()
	set_default_attributes(health, speed, damage)
	set_default_range()

func on_process(delta):
	set_default_rotation()
	movimentation(delta)

func shoot():
	shoot_animation.play("Shoot")
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position))
	get_parent().add_child(bullet)
	SoundSystem.play_sound_effect(pistol_shoot_sound)
