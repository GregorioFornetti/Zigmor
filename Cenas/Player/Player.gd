extends KinematicBody2D

onready var sprite = $Sprite
onready var shoot_timer = $Shoot_timer
onready var reload_timer = $Reload_timer
onready var Interface = get_parent().get_node("Interface")

enum {PISTOL, SHOTGUN, SNIPER}
var attributes = {
	"player" : {},
	PISTOL : {
		"bullet": preload('res://Cenas/Bullets/Pistol_bullet.tscn'),
		"damage": 5,
		"reload_time": 3,
		"fire_rate": 1,
		"magazine_capacity": 6
	},
	SHOTGUN : {
		"bullet": preload("res://Cenas/Bullets/Shotgun_bullet.tscn"),
		"damage": 1,
		"reload_time": 4,
		"fire_rate": 1.5,
		"magazine_capacity": 2
	},
	SNIPER : {
		"bullet": preload("res://Cenas/Bullets/Sniper_bullet.tscn"),
		"damage": 10,
		"reload_time": 5,
		"fire_rate": 2,
		"magazine_capacity": 5
	}
}
var weapons_status = {
	# Time left = tempo que faltou para poder atirar mais uma vez.
	PISTOL : {
		"qnt_reloaded_bullets": attributes[PISTOL]['magazine_capacity'],
		"qnt_total_bullets" : -1,  # numero negativo de balas representa que é infinito.
		"time_left": 0,
		"ready_to_shoot": true
	},
	SHOTGUN : {
		"qnt_reloaded_bullets": attributes[SHOTGUN]['magazine_capacity'],
		"qnt_total_bullets" : 10,
		"time_left": 0,
		"ready_to_shoot": true
	},
	SNIPER : {
		"qnt_reloaded_bullets": attributes[SNIPER]['magazine_capacity'],
		"qnt_total_bullets" : 20,
		"time_left": 0,
		"ready_to_shoot": true
	}
}
var velocity = Vector2.ZERO
var rotation_fix = PI / 2
var speed = 150
var current_weapon = PISTOL
var reloading = false


func _ready():
	update_weapons_interface()

func _input(event):
	if not event is InputEventMouseMotion:
		if event.get_action_strength("change_weapon_to_pistol"):
			change_weapon(PISTOL)
		elif event.get_action_strength("change_weapon_to_shotgun"):
			change_weapon(SHOTGUN)
		elif event.get_action_strength("change_weapon_to_sniper"):
			change_weapon(SNIPER)
		
		if event.get_action_strength("reload_weapon"):
			reload_current_weapon()
		
		if event.get_action_strength("shoot"):
			if weapons_status[current_weapon]['qnt_reloaded_bullets'] == 0:
				reload_current_weapon()
			elif weapons_status[current_weapon]['ready_to_shoot'] and not reloading:
				shoot()

func _process(delta):
	move_player(delta)
	rotate_player_to_mouse_dir()


func move_player(delta):
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_and_collide(velocity.normalized() * speed * delta)

func rotate_player_to_mouse_dir():
	rotation = (get_global_mouse_position() - global_position).angle() + rotation_fix

func update_weapons_interface():
	Interface.update_weaponAndAmmo_interface(current_weapon, weapons_status[current_weapon]['qnt_reloaded_bullets'], weapons_status[current_weapon]['qnt_total_bullets'])

func reload_current_weapon():
	if not reloading and weapons_status[current_weapon]['qnt_reloaded_bullets'] != attributes[current_weapon]['magazine_capacity'] and weapons_status[current_weapon]['qnt_total_bullets'] != 0:
		reloading = true
		reload_timer.start(attributes[current_weapon]['reload_time'])

func change_weapon(new_weapon):
	if new_weapon != current_weapon:
		if not weapons_status[current_weapon]['ready_to_shoot']:
			weapons_status[current_weapon]['time_left'] = shoot_timer.time_left
		if not weapons_status[new_weapon]['ready_to_shoot']:
			shoot_timer.start(weapons_status[new_weapon]['time_left'])
		
		sprite.frame = new_weapon
		current_weapon = new_weapon
		reloading = false
		reload_timer.stop()
		update_weapons_interface()

func shoot():
	var direction = Vector2(0, -1).rotated(rotation)
	if current_weapon == SHOTGUN:
		for i in range(12):
			instantiate_bullet(attributes[current_weapon]['bullet'], attributes[current_weapon]['damage'], direction.rotated(rand_range(-PI/12, PI/12)))
	else:
		instantiate_bullet(attributes[current_weapon]['bullet'], attributes[current_weapon]['damage'], direction)
	shoot_timer.start(attributes[current_weapon]['fire_rate'])
	weapons_status[current_weapon]['ready_to_shoot'] = false
	weapons_status[current_weapon]['qnt_reloaded_bullets'] -= 1
	update_weapons_interface()

func instantiate_bullet(bullet_type, damage, direction):
	var bullet = bullet_type.instance()
	bullet.initialize_bullet($Gun_pos.global_position, damage, direction)
	get_parent().add_child(bullet)


func _on_Shoot_timer_timeout():
	weapons_status[current_weapon]['ready_to_shoot'] = true

func _on_Reload_timer_timeout():
	reloading = false
	var bullets_to_reload = attributes[current_weapon]['magazine_capacity'] - weapons_status[current_weapon]['qnt_reloaded_bullets']
	
	if weapons_status[current_weapon]['qnt_total_bullets'] < 0:
		weapons_status[current_weapon]['qnt_reloaded_bullets'] = attributes[current_weapon]['magazine_capacity']
		
	elif weapons_status[current_weapon]['qnt_total_bullets'] >= bullets_to_reload:
		weapons_status[current_weapon]['qnt_reloaded_bullets'] = attributes[current_weapon]['magazine_capacity']
		weapons_status[current_weapon]['qnt_total_bullets'] -= bullets_to_reload
	
	else:
		weapons_status[current_weapon]['qnt_reloaded_bullets'] = weapons_status[current_weapon]['qnt_total_bullets']
		weapons_status[current_weapon]['qnt_total_bullets'] = 0
	update_weapons_interface()
