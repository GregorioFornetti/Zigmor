extends KinematicBody2D

var attributes = {}
onready var Player = get_parent().get_node("Player")
onready var healthbar_timer = $HealthBar_timer
onready var healthbar = $HealthBar
onready var collision_shape = $CollisionShape2D.shape
onready var enemy_hit_sound = preload("res://Sound/Effects/Collisions/enemy-hit.wav")
onready var enemy_death_sound = preload("res://Sound/Effects/Death/enemy-death.wav")
export (int) var points

signal enemy_spawn(enemy)
signal enemy_died(enemy)

func on_ready():
	pass

func on_process(delta):
	pass

func _process(delta):
	healthbar.set_rotation(-rotation)
	on_process(delta)

func _ready():
	var enemies_spawner = get_parent().get_node("Enemies_spawner")
	var interface = get_parent().get_node("Interface")
	
	connect("enemy_spawn", interface, "_on_enemy_spawn", [self])
	
	connect("enemy_died", enemies_spawner, "_on_enemy_death", [self])
	connect("enemy_died", interface, "_on_enemy_death", [self])
	connect("enemy_died", Game, "_on_enemy_death", [self])
	
	emit_signal("enemy_spawn")
	
	on_ready()
	healthbar.max_value = attributes['max_health']

func set_default_attributes(health, speed, damage):
	attributes['health'] = health
	attributes['max_health'] = health
	attributes['speed'] = speed
	attributes['damage'] = damage

func update_healthbar():
	healthbar.visible = true
	healthbar.value = attributes['health']
	healthbar_timer.start()

func die():
	Player.attributes["status"]['money'] += Game.get_enemy_monmey_drop(points)
	var interface = get_parent().get_node("Interface")
	interface.update_money(Player.attributes["status"]['money'])
	SoundSystem.play_sound_effect(enemy_death_sound)
	emit_signal("enemy_died")
	queue_free()

func get_damage():
	return attributes['damage']


func _on_HealthBar_timer_timeout():
	healthbar.visible = false

func _on_Hurtbox_area_entered(area):
	var player_bullet = area.get_parent()
	attributes['health'] -= player_bullet.get_damage()
	SoundSystem.play_sound_effect(enemy_hit_sound)
	if attributes['health'] <= 0 and not self.is_queued_for_deletion():
		die()
	else:
		update_healthbar()

