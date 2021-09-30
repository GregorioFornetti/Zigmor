extends KinematicBody2D

onready var sprite = $Sprite
onready var shoot_timer = $Shoot_timer
onready var reload_timer = $Reload_timer
onready var Interface = get_parent().get_node("Interface")
onready var shoot_animation = $ShootAnimations
onready var Pistol_bullet = preload('res://Scenes_and_scripts/Bullets/Pistol_bullet.tscn')
onready var Shotgun_bullet = preload("res://Scenes_and_scripts/Bullets/Shotgun_bullet.tscn")
onready var Sniper_bullet = preload("res://Scenes_and_scripts/Bullets/Sniper_bullet.tscn")
onready var pistol_shoot_sound = preload("res://Sound/Effects/Weapons/player-pistol-shoot.wav")
onready var death_sound = preload("res://Sound/Effects/Death/player-death.wav")

enum {PISTOL, SHOTGUN, SNIPER}
var attributes = {
	"speed" : 150,
	"max_health" : 100,
	"status" : {
		"health" : 100,
		"money" : 0
	},
	PISTOL : {
		"damage": 5,
		"reload_time": 3,
		"fire_rate": 1,
		"magazine_capacity": 6,
		"status" : {
			"qnt_reloaded_bullets": 6,
			"qnt_total_bullets" : -1,  # numero negativo de balas representa que é infinito.
			"time_left": 0,
			"ready_to_shoot": true
		}
	},
	SHOTGUN : {
		"damage": 1,
		"reload_time": 4,
		"fire_rate": 1.5,
		"magazine_capacity": 2,
		"status" : {
			"qnt_reloaded_bullets": 2,
			"qnt_total_bullets" : 10,
			"time_left": 0,
			"ready_to_shoot": true
		}
	},
	SNIPER : {
		"damage": 10,
		"reload_time": 5,
		"fire_rate": 2,
		"magazine_capacity": 5,
		"status" : {
			"qnt_reloaded_bullets": 5,
			"qnt_total_bullets" : 20,
			"time_left": 0,
			"ready_to_shoot": true
		}
	}
}

var velocity = Vector2.ZERO
var rotation_fix = PI / 2
var current_weapon = PISTOL
var reloading = false


func _ready():
	Game.Player = self
	update_weapons_interface()
	update_health_interface()
	update_weaponReloading_interface()
	update_money_interface()

func _input(event):
	if not event is InputEventMouseMotion and not Game.current_status == Game.status.SHOPPING:
		if event.get_action_strength("change_weapon_to_pistol"):
			change_weapon(PISTOL)
		elif event.get_action_strength("change_weapon_to_shotgun"):
			change_weapon(SHOTGUN)
		elif event.get_action_strength("change_weapon_to_sniper"):
			change_weapon(SNIPER)
		
		if event.get_action_strength("reload_weapon"):
			reload_current_weapon()

func _process(delta):
	move_player(delta)
	rotate_player_to_mouse_dir()
	update_weaponReloading_interface()
	
	verify_shoot_input()

func verify_shoot_input():
	# É preciso que seja colocado da função _input para que seja possível segurar o botao
	# de atirar e continuar atirando.
	# Se for colocado no _input, só atira uma vez se segurar o botão.
	if not Game.current_status == Game.status.SHOPPING and Input.is_action_pressed("shoot"):
		if attributes[current_weapon]['status']['qnt_reloaded_bullets'] == 0:
			reload_current_weapon()
		elif attributes[current_weapon]['status']['ready_to_shoot'] and not reloading:
			shoot()

func move_player(delta):
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_and_collide(velocity.normalized() * attributes['speed'] * delta)

func rotate_player_to_mouse_dir():
	rotation = (get_global_mouse_position() - global_position).angle() + rotation_fix

func update_weapons_interface():
	Interface.update_weaponAndAmmo(current_weapon, attributes[current_weapon]['status']['qnt_reloaded_bullets'], attributes[current_weapon]['status']['qnt_total_bullets'])

func update_health_interface():
	Interface.update_healthbar(attributes['status']['health'], attributes['max_health'])

func update_weaponReloading_interface():
	Interface.update_reloadbar(reload_timer.time_left, attributes[current_weapon]['reload_time'], reloading)

func update_money_interface():
	Interface.update_money(attributes.status.money)

func update_weapon_animation():
	if current_weapon == PISTOL:
		shoot_animation.play("Pistol")
	elif current_weapon == SHOTGUN:
		shoot_animation.play("Shotgun")
	else:
		shoot_animation.play("Sniper")

func reload_current_weapon():
	if not reloading and attributes[current_weapon]['status']['qnt_reloaded_bullets'] != attributes[current_weapon]['magazine_capacity'] and attributes[current_weapon]['status']['qnt_total_bullets'] != 0:
		reloading = true
		reload_timer.start(attributes[current_weapon]['reload_time'])

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
		update_weapons_interface()

func shoot():
	var direction = Vector2(0, -1).rotated(rotation)
	if current_weapon == PISTOL:
		SoundSystem.play_sound_effect(pistol_shoot_sound)
		instantiate_bullet(Pistol_bullet, attributes[current_weapon]['damage'], direction)
	elif current_weapon == SHOTGUN:
		for i in range(12):
			instantiate_bullet(Shotgun_bullet, attributes[current_weapon]['damage'], direction.rotated(rand_range(-PI/12, PI/12)))
	else:
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
	var enemy = area.get_parent()
	attributes['status']['health'] -= enemy.get_damage()
	if attributes['status']['health'] <= 0:
		die()
	else:
		update_health_interface()


func get_money():
	return attributes.status.money

func decrease_money(value):
	attributes.status.money -= value

func increase_money(value):
	attributes.status.money += value

func die():
	var final_menu = load("res://Scenes_and_scripts/Interfaces/Menus/Final_menu.tscn").instance()
	get_parent().add_child(final_menu)
	SoundSystem.play_sound_effect(death_sound)
	Game.current_status = Game.status.PAUSED
	get_tree().paused = true
