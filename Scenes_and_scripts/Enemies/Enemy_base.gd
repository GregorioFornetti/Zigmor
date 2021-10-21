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

func _input(event):
	if event.is_action_pressed("1_shop_select"):
		pass

func verify_colision(space_state, width, height, angle):
	# Verifica se há ocorrerá colisão a frente (rotacionado em angle).
	# width e height estão relacionados ao retângulo de colisão que será criado para verificar
	# a colisão
	# Se ocorrer uma colisão, o retorno é true, caso contrário é false.
	
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 0b00000000001000000000
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width, height)
	query.set_shape(shape)
	query.transform = Transform2D(rotation + deg2rad(angle), global_position + Vector2(0, -height).rotated(rotation + deg2rad(angle)))
	# Transform2D(rotation + deg2rad(angle), global_position + Vector2(0, -height).rotated(rotation + deg2rad(angle)))
	return len(space_state.collide_shape(query, 1)) != 0

func get_angle_to_dodge_obstacles(width, height):
	# Tenta retornar um angulo para o desvio de obstaculos
	# Width e heigth estão relacionados aos retângulos de colisão que serão criados
	# para verificar obstaculos. Width deve ser da largura do inimigo e height
	# quanto maior for, o inimigo detectará antes o obstaculo
	var space_state = get_world_2d().direct_space_state
	
	if not verify_colision(space_state, width, height, 0):
		return 0
	
	for angle in range(5, 181, 5):
		if not verify_colision(space_state, width, height, angle):
			return angle
	
	for angle in range(-5, -181, -5):
		if not verify_colision(space_state, width, height, angle):
			return angle
	
	return 0


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

