extends "res://Scenes_and_scripts/Enemies/Enemy_shooter_chaser.gd"

var aiming = false
var in_range = false
const BULLET_WIDTH = Vector2(10,0)

onready var shoot_animation = $ShootAnimation
onready var sniper_shoot_sound = preload("res://Sound/Effects/Weapons/Enemies/enemy-sniper-shoot.wav")
onready var Bullet = preload("res:///Scenes_and_scripts/Bullets/Enemy_sniper_bullet.tscn")

func _draw():
	if aiming:
		draw_line($Weapon_pos.position, (Player.global_position - global_position).rotated(-rotation), ColorN("Red"))
		#draw_line($Weapon_pos.position + BULLET_WIDTH, (Player.global_position + BULLET_WIDTH.rotated(rotation) - global_position).rotated(-rotation), ColorN("Red"))
		#draw_line($Weapon_pos.position - BULLET_WIDTH, (Player.global_position - BULLET_WIDTH.rotated(rotation) - global_position).rotated(-rotation), ColorN("Red"))

func on_ready():
	var health = 20 + Game.get_enemies_points() * 4
	var speed = min(90 + Game.get_enemies_points() * 2, 250)
	var damage = 5 + Game.get_enemies_points()
	set_default_attributes(health, speed, damage)


func on_process(delta):
	update()
	set_default_rotation()
	if aiming:
		if not is_path_to_player_free():
			$Timer_shoot.stop()
			aiming = false
	elif in_range:
		if is_path_to_player_free():
			$Timer_shoot.start()
			aiming = true
		movimentation(delta)
	else:
		movimentation(delta)


func is_path_to_player_free():
	var space_state = get_world_2d().direct_space_state
	var result1 = space_state.intersect_ray(global_position + BULLET_WIDTH.rotated(rotation),\
				  Player.global_position + BULLET_WIDTH.rotated(rotation), [self, Player])
	var result2 = space_state.intersect_ray(global_position - BULLET_WIDTH.rotated(rotation),\
				  Player.global_position - BULLET_WIDTH.rotated(rotation), [self, Player])
	return not result1 and not result2

func _on_Range_body_entered(_body):
	in_range = true

func _on_Range_body_exited(_body):
	in_range = false

func _on_Timer_shoot_timeout():
	shoot()
	if not in_range:
		aiming = false
		$Timer_shoot.stop()

func shoot():
	shoot_animation.play("Shoot")
	var bullet = Bullet.instance()
	bullet.initialize_bullet(weapon_position.global_position, attributes['damage'], global_position.direction_to(Player.global_position))
	get_parent().add_child(bullet)
	SoundSystem.play_sound_effect(sniper_shoot_sound)
