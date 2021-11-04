extends KinematicBody2D

const PISTOL_INITIAL_SOUND_DURATION = 3.0
const SHOTGUN_INITIAL_SOUND_DURATION = 4.0
const SNIPER_INITIAL_SOUND_DURATION = 5.0

onready var sprite = $Sprite
onready var shoot_timer = $Shoot_timer
onready var reload_timer = $Reload_timer
onready var Interface = get_parent().get_node("Interface")
onready var shoot_animation = $ShootAnimations
onready var dash_reload_timer = $Dash_reload_timer
onready var pistol_power_reloadtimer = $Pistol_power_reload_timer
onready var shotgun_power_reloadtimer = $Shotgun_power_reload_timer
onready var sniper_power_reloadtimer = $Sniper_power_reload_timer
onready var Pistol_bullet = preload('res://Scenes_and_scripts/Bullets/Pistol_bullet.tscn')
onready var Shotgun_bullet = preload("res://Scenes_and_scripts/Bullets/Shotgun_bullet.tscn")
onready var Sniper_bullet = preload("res://Scenes_and_scripts/Bullets/Sniper_bullet.tscn")

onready var pistol_shoot_sound = preload("res://Sound/Effects/Weapons/Player/Shoot/player-pistol-shoot.wav")
onready var shotgun_shoot_sound = preload("res://Sound/Effects/Weapons/Player/Shoot/player-shotgun-shoot.wav")
onready var sniper_shoot_sound = preload("res://Sound/Effects/Weapons/Player/Shoot/player-sniper-shoot.wav")
onready var pistol_reload_sound = preload("res://Sound/Effects/Weapons/Player/Reload/player-pistol-reload.wav")
onready var shotgun_reload_sound = preload("res://Sound/Effects/Weapons/Player/Reload/player-shotgun-reload.wav")
onready var sniper_reload_sound = preload("res://Sound/Effects/Weapons/Player/Reload/player-sniper-reload.wav")

onready var pistol_power_icon = preload("res://Sprites/Interface/Game-interface/Pistol-power-icon.png")
onready var shotgun_power_icon = preload("res://Sprites/Interface/Game-interface/Shotgun-power-icon.png")
onready var sniper_power_icon = preload("res://Sprites/Interface/Game-interface/Sniper-power-icon.png")

onready var death_sound = preload("res://Sound/Effects/Death/player-death.wav")

enum {NO_POWER, PISTOL_POWER, SHOTGUN_POWER, SNIPER_POWER}
enum {DASHING, POWER, NORMAL}
enum {PISTOL, SHOTGUN, SNIPER}

var attributes = {
	"speed" : 250,
	"max_health" : 100,
	"life_regen": 1,
	"status" : {
		"health" : 100,
		"money" : 0,
		"qnt_available_dashes": 1
	},
	
	"dash": {
		"qnt_total_dashes": 1,
		"reload_time": 5
	},
	
	PISTOL : {
		"damage": 5,
		"reload_time": 2,
		"fire_rate": 0.5,
		"magazine_capacity": 6,
		"status" : {
			"qnt_reloaded_bullets": 6,
			"qnt_total_bullets" : -1,  # numero negativo de balas representa que é infinito.
			"time_left": 0,
			"ready_to_shoot": true
		},
		"power" : {
			"duration" : 5,
			"reload_time": 60
		}
	},
	SHOTGUN : {
		"damage": 1,
		"reload_time": 3,
		"fire_rate": 1,
		"magazine_capacity": 2,
		"status" : {
			"qnt_reloaded_bullets": 2,
			"qnt_total_bullets" : 10,
			"time_left": 0,
			"ready_to_shoot": true
		},
		"power" : {
			"reload_time": 60
		}
	},
	SNIPER : {
		"damage": 10,
		"reload_time": 3,
		"fire_rate": 1,
		"magazine_capacity": 5,
		"status" : {
			"qnt_reloaded_bullets": 5,
			"qnt_total_bullets" : 20,
			"time_left": 0,
			"ready_to_shoot": true
		},
		"power" : {
			"reload_time": 60
		}
	}
}

var velocity = Vector2.ZERO
var rotation_fix = PI / 2
var current_weapon = PISTOL
var reloading = false
var current_reload_effect
var movement_status = NORMAL
var power_status = NO_POWER



func _ready():
	Game.Player = self
	update_weapons_interface()
	update_health_interface()
	update_weaponReloading_interface()
	update_money_interface()

func _input(event):
	if not event is InputEventMouseMotion and not Game.current_status == Game.status.SHOPPING:
		if power_status == NO_POWER:
			if event.get_action_strength("change_weapon_to_pistol"):
				Interface.update_weapon_power_icon(pistol_power_icon)
				change_weapon(PISTOL)
			elif event.get_action_strength("change_weapon_to_shotgun"):
				Interface.update_weapon_power_icon(shotgun_power_icon)
				change_weapon(SHOTGUN)
			elif event.get_action_strength("change_weapon_to_sniper"):
				Interface.update_weapon_power_icon(sniper_power_icon)
				change_weapon(SNIPER)
		
		if event.get_action_strength("reload_weapon"):
			reload_current_weapon()
		
		if event.get_action_strength("weapon_special_ability"):
			start_power()
		
		if event.get_action_strength("dash"):
			start_dash()

func _process(delta):
	move_player(delta)
	rotate_player_to_mouse_dir()
	update_weaponReloading_interface()
	update_dash_interface()
	update_weapon_power_interface()
	
	verify_shoot_input()

func verify_shoot_input():
	# É preciso que seja colocado fora da função _input para que seja possível segurar o botao
	# de atirar e continuar atirando.
	# Se for colocado no _input, só atira uma vez se segurar o botão.
	if not Game.current_status == Game.status.SHOPPING and power_status == NO_POWER and Input.is_action_pressed("shoot"):
		if attributes[current_weapon]['status']['qnt_reloaded_bullets'] == 0:
			reload_current_weapon()
		elif attributes[current_weapon]['status']['ready_to_shoot'] and not reloading:
			shoot()

func move_player(delta):
	if movement_status == NORMAL:
		velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		move_and_slide(velocity.normalized() * attributes['speed'] * delta * 50)
	
	else:  #DASHING
		move_and_slide(velocity.normalized() * (attributes['speed'] * 3) * delta * 50)

func start_dash():
	if not movement_status == DASHING and attributes.status.qnt_available_dashes > 0:
		movement_status = DASHING
		velocity = global_position.direction_to(get_global_mouse_position())
		$Dash_timer.start()

func _on_Dash_timer_timeout():
	movement_status = NORMAL
	attributes.status.qnt_available_dashes -= 1
	if dash_reload_timer.time_left == 0:
		$Dash_reload_timer.start(attributes.dash.reload_time)

func _on_Dash_reload_timer_timeout():
	attributes.status.qnt_available_dashes += 1
	if attributes.status.qnt_available_dashes < attributes.dash.qnt_total_dashes:
		$Dash_reload_timer.start(attributes.dash.reload_time)
	

func rotate_player_to_mouse_dir():
	if power_status != PISTOL_POWER:
		rotation = (get_global_mouse_position() - global_position).angle() + rotation_fix

func update_weapons_interface():
	Interface.update_weaponAndAmmo(current_weapon, attributes[current_weapon]['status']['qnt_reloaded_bullets'], attributes[current_weapon]['status']['qnt_total_bullets'])

func update_health_interface():
	Interface.update_healthbar(attributes['status']['health'], attributes['max_health'])

func update_weaponReloading_interface():
	Interface.update_reloadbar(reload_timer.time_left, attributes[current_weapon]['reload_time'], reloading)

func update_money_interface():
	Interface.update_money(attributes.status.money)

func update_dash_interface():
	Interface.update_dash_box(attributes.dash.reload_time - dash_reload_timer.time_left, 
							  attributes.dash.reload_time, 
							  attributes.status.qnt_available_dashes)

func update_weapon_power_interface():
	var timer
	if current_weapon == PISTOL:
		timer = pistol_power_reloadtimer
	elif current_weapon == SHOTGUN:
		timer = shotgun_power_reloadtimer
	else:
		timer = sniper_power_reloadtimer
	Interface.update_weapon_power_progress_bar(attributes[current_weapon].power.reload_time - timer.time_left,
											  attributes[current_weapon].power.reload_time)

func update_weapon_animation():
	if current_weapon == PISTOL:
		shoot_animation.play("Pistol")
	elif current_weapon == SHOTGUN:
		shoot_animation.play("Shotgun")
	else:
		shoot_animation.play("Sniper")

func reload_current_weapon():
	if not reloading and power_status == NO_POWER and attributes[current_weapon]['status']['qnt_reloaded_bullets'] != attributes[current_weapon]['magazine_capacity'] and attributes[current_weapon]['status']['qnt_total_bullets'] != 0:
		reloading = true
		reload_timer.start(attributes[current_weapon]['reload_time'])
		
		if current_weapon == PISTOL:
			current_reload_effect = SoundSystem.play_sound_effect_with_config( \
			pistol_reload_sound, PISTOL_INITIAL_SOUND_DURATION / attributes[current_weapon]['reload_time'])
		elif current_weapon == SHOTGUN:
			current_reload_effect = SoundSystem.play_sound_effect_with_config( \
			shotgun_reload_sound, SHOTGUN_INITIAL_SOUND_DURATION / attributes[current_weapon]['reload_time'])
		else:
			current_reload_effect = SoundSystem.play_sound_effect_with_config( \
			shotgun_reload_sound, SNIPER_INITIAL_SOUND_DURATION / attributes[current_weapon]['reload_time'])


func change_weapon(new_weapon):
	if new_weapon != current_weapon:
		if not attributes[current_weapon]['status']['ready_to_shoot']:
			attributes[current_weapon]['status']['time_left'] = shoot_timer.time_left
		if not attributes[new_weapon]['status']['ready_to_shoot']:
			shoot_timer.start(attributes[new_weapon]['status']['time_left'])
		
		sprite.frame = new_weapon
		current_weapon = new_weapon
		reloading = false
		reload_timer.stop()
		shoot_animation.stop()
		if current_reload_effect:
			current_reload_effect.stop()
			current_reload_effect = null
		update_weapons_interface()

func shoot():
	var direction = Vector2(0, -1).rotated(rotation)
	if current_weapon == PISTOL:
		SoundSystem.play_sound_effect(pistol_shoot_sound)
		instantiate_bullet(Pistol_bullet, attributes[current_weapon]['damage'], direction)
	elif current_weapon == SHOTGUN:
		SoundSystem.play_sound_effect(shotgun_shoot_sound)
		for i in range(12):
			instantiate_bullet(Shotgun_bullet, attributes[current_weapon]['damage'], direction.rotated(rand_range(-PI/12, PI/12)))
	else:
		SoundSystem.play_sound_effect(sniper_shoot_sound)
		instantiate_bullet(Sniper_bullet, attributes[current_weapon]['damage'], direction)
	
	shoot_timer.start(attributes[current_weapon]['fire_rate'])
	attributes[current_weapon]['status']['ready_to_shoot'] = false
	attributes[current_weapon]['status']['qnt_reloaded_bullets'] -= 1
	update_weapons_interface()
	update_weapon_animation()

func instantiate_bullet(bullet_type, damage, direction):
	var bullet = bullet_type.instance()
	bullet.initialize_bullet($Gun_pos.global_position, damage, direction)
	get_parent().add_child(bullet)


func start_power():
	if power_status == NO_POWER and not reloading:
		if current_weapon == PISTOL and pistol_power_reloadtimer.time_left == 0:
			start_pistol_power()

func _on_Power_duration_timeout():
	if power_status == PISTOL_POWER:
		$Pistol_power_shoot_timer.stop()
		pistol_power_reloadtimer.start(attributes[PISTOL].power.reload_time)
		
	power_status = NO_POWER

func start_pistol_power():
	power_status = PISTOL_POWER
	$Power_duration.start(attributes[PISTOL].power.duration)
	if attributes[PISTOL].fire_rate <= 0.25:
		$Pistol_power_shoot_timer.start(attributes[PISTOL].fire_rate / 2)
	else:
		$Pistol_power_shoot_timer.start(attributes[PISTOL].fire_rate / 4)

func _on_Pistol_power_shoot_timer_timeout():
	instantiate_bullet(Pistol_bullet, attributes[PISTOL].damage, Vector2(0, -1).rotated(rotation))


func _on_Shoot_timer_timeout():
	attributes[current_weapon]['status']['ready_to_shoot'] = true

func _on_Reload_timer_timeout():
	reloading = false
	var bullets_to_reload = attributes[current_weapon]['magazine_capacity'] - attributes[current_weapon]['status']['qnt_reloaded_bullets']
	
	if attributes[current_weapon]['status']['qnt_total_bullets'] < 0:
		attributes[current_weapon]['status']['qnt_reloaded_bullets'] = attributes[current_weapon]['magazine_capacity']
		
	elif attributes[current_weapon]['status']['qnt_total_bullets'] >= bullets_to_reload:
		attributes[current_weapon]['status']['qnt_reloaded_bullets'] = attributes[current_weapon]['magazine_capacity']
		attributes[current_weapon]['status']['qnt_total_bullets'] -= bullets_to_reload
	
	else:
		attributes[current_weapon]['status']['qnt_reloaded_bullets'] = attributes[current_weapon]['status']['qnt_total_bullets']
		attributes[current_weapon]['status']['qnt_total_bullets'] = 0
	update_weapons_interface()

func _on_Hurtbox_area_entered(area):
	if not movement_status == DASHING:
		var enemy_bullet = area.get_parent()
		attributes['status']['health'] -= enemy_bullet.get_damage()
		if attributes['status']['health'] <= 0:
			die()
		else:
			update_health_interface()
		$Life_regen_timer.start()


func get_money():
	return attributes.status.money

func decrease_money(value):
	attributes.status.money -= value

func increase_money(value):
	attributes.status.money += value

func die():
	if not is_queued_for_deletion():
		var final_menu = load("res://Scenes_and_scripts/Interfaces/Menus/Final_menu.tscn").instance()
		get_parent().add_child(final_menu)
		SoundSystem.play_sound_effect(death_sound)
		Game.current_status = Game.status.PAUSED
		queue_free()
		get_tree().paused = true


func _on_Life_regen_timer_timeout():
	attributes.status.health = min(attributes.status.health + attributes.life_regen, \
								   attributes.max_health)
	update_health_interface()
	if attributes.status.health == attributes.max_health:
		$Life_regen_timer.stop()

