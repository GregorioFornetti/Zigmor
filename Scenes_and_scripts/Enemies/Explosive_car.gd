extends "res://Scenes_and_scripts/Enemies/Enemy_base.gd"

onready var Explosion = preload("res://Scenes_and_scripts/Explosions/Explosion.tscn")
const rotation_fix = PI / 2

func on_ready():
	var health = 20 + Game.get_enemies_points()
	var speed = min(300 + Game.get_enemies_points() * 5, 800)
	var damage = 5 + Game.get_enemies_points()
	set_default_attributes(health, speed, damage)

func on_process(delta):
	if movement_status == NORMAL:
		var dodge_rotation = get_angle_to_dodge_obstacles($CollisionShape2D.shape.extents.x, 100)
		move_and_slide(global_position.direction_to(Player.global_position).rotated(deg2rad(dodge_rotation)) * attributes['speed'] * delta * 50)
	else:
		move_and_slide(-global_position.direction_to(Player.global_position) * attributes['speed'] * delta * 50)
	
	rotation = (Player.global_position - global_position).angle() + rotation_fix


func _on_Danger_area_body_entered(body):
	$Sprite.frame = 1

func _on_Danger_area_body_exited(body):
	$Sprite.frame = 0


func _on_Explosion_area_body_entered(body):
	var explosion = Explosion.instance()
	explosion.damage = attributes['damage']
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	SoundSystem.play_sound_effect(enemy_death_sound)
	emit_signal("enemy_died")
	queue_free()
